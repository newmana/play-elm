module PlayElm.Update exposing (update)

import Array as Array
import Dict as Dict
import PlayElm.Model as Model
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Programs.Balls as Balls
import PlayElm.Programs.Circle as Circle
import PlayElm.Programs.LineTenPrint as LineTenPrint
import PlayElm.Programs.LineTenPrintUpdate as LineTenPrintUpdate
import PlayElm.Programs.Update as Update
import PlayElm.Types as Types
import PlayElm.Util as Util
import Random as Random
import Time as Time
import Tuple as Tuple


update : Msg.Msg -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
update msg model =
    case ( msg, model ) of
        ( Msg.Tick newTime, Model.Booting bmm ) ->
            ( Model.tick newTime bmm, Port.getBoundingClientRect Model.elementId ) |> Tuple.mapFirst Model.Booting

        ( Msg.Tick newTime, Model.Running rmm ) ->
            if rmm.context.running then
                rmm.config.step newTime rmm.context |> toModel rmm Model.Executing

            else
                ( Model.tick newTime rmm.context, Port.getBoundingClientRect Model.elementId ) |> toModel rmm Model.Executing

        ( Msg.Tick newTime, Model.Executing emm ) ->
            if emm.context.running then
                emm.config.updateWithMsg emm.context |> toModel emm Model.Running

            else
                ( Model.tick newTime emm.context, Port.getBoundingClientRect Model.elementId ) |> toModel emm Model.Running

        ( Msg.RandomString str, Model.Executing emm ) ->
            if emm.context.running then
                let
                    getContext =
                        emm.context

                    getDoers =
                        getContext.doers

                    newDoers =
                        { getDoers | generatedValue = str }

                    newContext =
                        { getContext | doers = newDoers }
                in
                emm.config.updateWithMsg newContext |> toModel emm Model.Running

            else
                ( model, Port.getBoundingClientRect Model.elementId )

        ( Msg.MouseMove e, Model.Booting bm ) ->
            mouseMove e.pagePos bm |> Tuple.mapFirst Model.Booting

        ( Msg.MouseMove e, Model.Running rm ) ->
            mouseMove e.pagePos rm.context |> toModel rm Model.Running

        ( Msg.SetBoundingClientRect r, Model.Booting bm ) ->
            let
                newModel =
                    { bm | clientRect = r }
            in
            ( boot newModel, Cmd.none )

        ( Msg.SetComputedStyle s, Model.Booting bm ) ->
            let
                newModel =
                    { bm | computedStyle = s }
            in
            ( boot newModel, Cmd.none )

        _ ->
            ( model, Cmd.none )


timeToFloat : Time.Posix -> Float
timeToFloat t =
    Time.posixToMillis t |> toFloat


mouseMove : ( Float, Float ) -> Types.CommonProperties a -> ( Types.CommonProperties a, Cmd msg )
mouseMove pos m =
    ( { m | pointer = pos }, Cmd.none )


type alias Stuff =
    { config : Model.Config Msg.Msg
    , doers : Types.Doers
    }


standardUpdate : Model.Config Msg.Msg
standardUpdate =
    { updateWithMsg = Update.updateWithMsg
    , step = Update.step
    }


programs : Dict.Dict String Stuff
programs =
    Dict.fromList
        [ ( "Balls"
          , { config = standardUpdate
            , doers =
                { runner = Balls.run
                , generator = LineTenPrint.generateMaze
                , generatedValue = ""
                }
            }
          )
        , ( "Circle"
          , { config = standardUpdate
            , doers =
                { runner = Circle.run
                , generator = LineTenPrint.generateMaze
                , generatedValue = ""
                }
            }
          )
        , ( "LineTenPrint"
          , { config =
                { updateWithMsg = LineTenPrintUpdate.updateWithMsg
                , step = LineTenPrintUpdate.step
                }
            , doers =
                { runner = Types.idRunner
                , generator = LineTenPrint.generateMaze
                , generatedValue = ""
                }
            }
          )
        ]


boot : Model.BootingModel -> Model.Model
boot m =
    case ( m.clientRect, m.computedStyle ) of
        ( Just cr, Just cs ) ->
            let
                cols =
                    floor (cr.width / cs.cellWidth)

                rows =
                    floor (cr.height / cs.lineHeight)

                context =
                    { pointer = m.pointer
                    , time = m.time
                    , clientRect = cr
                    , computedStyle = cs
                    , aspect = cs.cellWidth / cs.lineHeight
                    , rows = rows
                    , cols = cols
                    , screen = Array.empty
                    , running = True
                    , doers =
                        { runner = Types.idRunner
                        , generator = LineTenPrint.generateMaze
                        , generatedValue = ""
                        }
                    }

                config =
                    { updateWithMsg = LineTenPrintUpdate.updateWithMsg
                    , step = LineTenPrintUpdate.step
                    }
            in
            Model.Running
                { context = context
                , config = config
                }

        ( _, _ ) ->
            Model.Booting m


toModel : Model.RunningModel -> (Model.RunningModel -> Model.Model) -> (( Types.Context, b ) -> ( Model.Model, b ))
toModel emm m =
    Tuple.mapFirst (\x -> { emm | context = x } |> m)
