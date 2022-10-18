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


update : Msg.Msg -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
update msg model =
    case ( msg, model ) of
        ( Msg.Tick newTime, (Model.Booting _) as bm ) ->
            ( Model.tick newTime bm, Port.getBoundingClientRect Model.elementId )

        ( Msg.GenerateMaze row newLine, Model.Running rm ) ->
            LineTenPrintUpdate.step row newLine model

        ( Msg.Tick newTime, (Model.Running rmm) as rm ) ->
            if rmm.running then
                ( model, Cmd.none )
                    |> Util.andThen
                        LineTenPrintUpdate.updateWithMsg
                --( model, Cmd.none )
                --    |> Util.andThen
                --        (Update.updateWithMsg rmm.config)
                --    |> Util.andThen
                --        (Update.step rmm.config newTime)

            else
                ( Model.tick newTime rm, Port.getBoundingClientRect Model.elementId )

        ( Msg.MouseMove e, Model.Booting bm ) ->
            mouseMove e.pagePos bm |> Tuple.mapFirst Model.Booting

        ( Msg.MouseMove e, Model.Running rm ) ->
            mouseMove e.pagePos rm |> Tuple.mapFirst Model.Running

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
            in
            Model.Running
                { pointer = m.pointer
                , time = m.time
                , clientRect = cr
                , computedStyle = cs
                , aspect = cs.cellWidth / cs.lineHeight
                , rows = rows
                , cols = cols
                , screen = Array.empty
                , running = True
                , config = { runner = Circle.run }
                }

        ( _, _ ) ->
            Model.Booting m
