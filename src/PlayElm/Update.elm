module PlayElm.Update exposing (update)

import Array as Array
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
                Update.step rmm.context.doers newTime rmm.context |> toRunning rmm Model.Executing

            else
                ( Model.tick newTime rmm.context, Port.getBoundingClientRect Model.elementId ) |> toRunning rmm Model.Executing

        ( Msg.Tick newTime, Model.Executing emm ) ->
            if emm.context.running then
                Update.updateWithMsg emm.context.doers emm.context |> toRunning emm Model.Running

            else
                ( Model.tick newTime emm.context, Port.getBoundingClientRect Model.elementId ) |> toRunning emm Model.Running

        ( Msg.MouseMove e, Model.Booting bm ) ->
            mouseMove e.pagePos bm |> Tuple.mapFirst Model.Booting

        ( Msg.MouseMove e, Model.Running rm ) ->
            mouseMove e.pagePos rm.context |> toRunning rm Model.Running

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


mouseMove : ( Float, Float ) -> Model.CommonProperties a -> ( Model.CommonProperties a, Cmd msg )
mouseMove pos m =
    ( { m | pointer = pos }, Cmd.none )


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
                        { runner = Circle.run
                        , generator = LineTenPrint.generateMaze
                        }
                    }

                config =
                    { updateWithMsg = Update.updateWithMsg
                    , step = Update.step
                    }
            in
            Model.Running
                { context = context
                , config = config
                }

        ( _, _ ) ->
            Model.Booting m


toRunning : Model.RunningModel -> (Model.RunningModel -> Model.Model) -> (( Model.Context, b ) -> ( Model.Model, b ))
toRunning emm m =
    Tuple.mapFirst (\x -> { emm | context = x } |> m)
