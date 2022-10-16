module PlayElm.Update exposing (update)

import Array as Array
import PlayElm.Model as Model
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Programs.Balls as Balls
import PlayElm.Programs.Circle as Circle
import PlayElm.Programs.LineTenPrint as LineTenPrint
import PlayElm.Types as Types
import PlayElm.Util as Util
import Random as Random
import Time as Time


update : Msg.Msg -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
update msg model =
    case ( msg, model ) of
        ( Msg.Tick newTime, (Model.Booting _) as bm ) ->
            ( Model.tick newTime bm, Port.getBoundingClientRect Model.elementId )

        ( Msg.GenerateMaze row st, Model.Running rm ) ->
            let
                newScreen =
                    Array.push st rm.screen

                newRm =
                    { rm | screen = newScreen }
            in
            if row > 0 then
                ( Model.Running newRm, Random.generate (Msg.GenerateMaze (row - 1)) (LineTenPrint.generateMaze rm.cols) )

            else
                ( Model.Running { newRm | running = False }, Port.getBoundingClientRect Model.elementId )

        ( Msg.GenerateBalls, Model.Running rm ) ->
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
            ( Model.Running newRm, Cmd.none )

        ( Msg.GenerateCircle, Model.Running rm ) ->
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
                    List.foldl (\colNum str -> str ++ Circle.run context colNum rowNum) "" (List.range 0 (rm.cols - 1))

                newScreen =
                    List.foldl (\rowNum -> Array.push (row rowNum)) Array.empty (List.range 0 (rm.rows - 1))

                newRm =
                    { rm | screen = newScreen }
            in
            ( Model.Running newRm, Cmd.none )

        ( Msg.Tick newTime, (Model.Running rmm) as rm ) ->
            if rmm.running then
                --( rm, Random.generate (Msg.GenerateMaze rmm.rows) (LineTenPrint.generateMaze rmm.cols) )
                --let
                --    ( newM, newMsg ) =
                --        update Msg.GenerateBalls rm
                --in
                --( Model.tick newTime newM, Port.getBoundingClientRect Model.elementId )
                let
                    ( newM, newMsg ) =
                        update Msg.GenerateCircle rm
                in
                ( Model.tick newTime newM, Port.getBoundingClientRect Model.elementId )

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
                }

        ( _, _ ) ->
            Model.Booting m
