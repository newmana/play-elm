module PlayElm.Programs.LineTenPrintUpdate exposing (..)

import Array as Array
import PlayElm.Model as Model
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Programs.LineTenPrint as LineTenPrint
import Random as Random


update : Model.Model -> ( Model.Model, Cmd Msg.Msg )
update model =
    case model of
        (Model.Running rmm) as rm ->
            ( rm, Random.generate (Msg.GenerateMaze rmm.rows) (LineTenPrint.generateMaze rmm.cols) )

        _ ->
            ( model, Port.getBoundingClientRect Model.elementId )


step : Int -> String -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
step row st model =
    case model of
        (Model.Running rmm) as rm ->
            let
                newScreen =
                    Array.push st rmm.screen

                newRm =
                    { rmm | screen = newScreen }
            in
            if row > 0 then
                ( Model.Running newRm, Random.generate (Msg.GenerateMaze (row - 1)) (LineTenPrint.generateMaze rmm.cols) )

            else
                ( Model.Running { newRm | running = False }, Port.getBoundingClientRect Model.elementId )

        _ ->
            ( model, Port.getBoundingClientRect Model.elementId )
