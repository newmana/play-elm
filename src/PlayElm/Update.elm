module PlayElm.Update exposing (update)

import Array as Array
import PlayElm.Model as Model
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Programs.Balls as Balls
import PlayElm.Programs.LineTenPrint as LineTenPrint
import PlayElm.Types as Types
import PlayElm.Util as Util
import Time as Time


update : Msg.Msg -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
update msg model =
    case ( msg, model ) of
        ( Msg.Tick newTime, Model.Booting bm ) ->
            tick newTime bm |> Tuple.mapFirst Model.Booting

        ( Msg.Tick newTime, Model.Running rm ) ->
            let
                context =
                    { time = rm.time
                    , cols = rm.cols
                    , rows = rm.rows
                    , width = rm.clientRect.width
                    , height = rm.clientRect.height
                    , aspect = rm.aspect
                    }

                row rowNum =
                    List.foldl (\colNum str -> str ++ Balls.run context colNum rowNum) "" (List.range 0 (rm.cols - 1))

                newScreen =
                    List.foldl (\rowNum -> Array.push (row rowNum)) Array.empty (List.range 0 (rm.rows - 1))

                newRm =
                    { rm | screen = newScreen }
            in
            tick newTime newRm |> Tuple.mapFirst Model.Running

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


tick : Float -> Model.CommonProperties a -> ( Model.CommonProperties a, Cmd msg )
tick delta m =
    ( { m | time = m.time + delta }, Port.getBoundingClientRect Model.elementId )


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
                }

        ( _, _ ) ->
            Model.Booting m
