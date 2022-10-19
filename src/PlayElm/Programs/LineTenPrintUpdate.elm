module PlayElm.Programs.LineTenPrintUpdate exposing (..)

import Array as Array
import PlayElm.Model as Model
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Programs.LineTenPrint as LineTenPrint
import PlayElm.Types as Types
import Random as Random


foo =
    Debug.log "" ""



--updateWithMsg : Model.Model -> ( Model.Model, Cmd Msg.Msg )
--updateWithMsg model =
--    case model of
--        (Model.Running rmm) as rm ->
--            ( rm, Random.generate (Msg.Step rmm.rows) (LineTenPrint.generateMaze rmm.cols) )
--
--        _ ->
--            ( model, Port.getBoundingClientRect Model.elementId )
--
--
--step2 : Types.Doers -> Float -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
--step2 doers newTime model =
--    case model of
--        (Model.Running rmm) as rm ->
--            ( rm, Random.generate (Msg.Step rmm.rows) (doers.generator (rmm.cols * rmm.rows)) )
--
--        _ ->
--            ( model, Port.getBoundingClientRect Model.elementId )
--
--step : Int -> String -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
--step row newLine model =
--    case model of
--        (Model.Running rmm) as rm ->
--            let
--                newScreen =
--                    Array.push newLine rmm.screen
--
--                newRm =
--                    { rmm | screen = newScreen }
--            in
--            if row > 0 then
--                ( Model.Running newRm, Random.generate (Msg.Step (row - 1)) (LineTenPrint.generateMaze rmm.cols) )
--
--            else
--                ( Model.Running { newRm | running = False }, Port.getBoundingClientRect Model.elementId )
--
--        _ ->
--            ( model, Port.getBoundingClientRect Model.elementId )
