module PlayElm.Programs.Update exposing (..)

import Array as Array
import PlayElm.Model as Model
import PlayElm.Modules.Sdf as Sdf
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Programs.Balls as Balls
import PlayElm.Types as Types


updateWithMsg : Types.Config -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
updateWithMsg config model =
    case model of
        (Model.Running rmm) as rm ->
            let
                context =
                    { time = rmm.time
                    , cols = rmm.cols
                    , rows = rmm.rows
                    , width = rmm.clientRect.width
                    , height = rmm.clientRect.height
                    , aspect = rmm.aspect
                    }

                row rowNum =
                    List.foldl (\colNum str -> str ++ config.runner context colNum rowNum) "" (List.range 0 (rmm.cols - 1))

                newScreen =
                    List.foldl (\rowNum -> Array.push (row rowNum)) Array.empty (List.range 0 (rmm.rows - 1))

                newRm =
                    { rmm | screen = newScreen }
            in
            ( Model.Running newRm, Port.getBoundingClientRect Model.elementId )

        _ ->
            ( model, Port.getBoundingClientRect Model.elementId )


step : Types.Config -> Float -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
step _ newTime model =
    ( Model.tick newTime model, Port.getBoundingClientRect Model.elementId )
