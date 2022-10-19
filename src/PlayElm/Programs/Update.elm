module PlayElm.Programs.Update exposing (..)

import Array as Array
import PlayElm.Model as Model
import PlayElm.Modules.Sdf as Sdf
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Programs.Balls as Balls
import PlayElm.Types as Types


updateWithMsg : Types.Doers -> Model.Context -> ( Model.Context, Cmd Msg.Msg )
updateWithMsg config context =
    let
        localContext =
            { time = context.time
            , cols = context.cols
            , rows = context.rows
            , width = context.clientRect.width
            , height = context.clientRect.height
            , aspect = context.aspect
            }

        row rowNum =
            List.foldl (\colNum str -> str ++ config.runner localContext colNum rowNum) "" (List.range 0 (context.cols - 1))

        newScreen =
            List.foldl (\rowNum -> Array.push (row rowNum)) Array.empty (List.range 0 (context.rows - 1))

        newExecuting =
            { context | screen = newScreen }
    in
    ( newExecuting, Port.getBoundingClientRect Model.elementId )


step : Types.Doers -> Float -> Model.Context -> ( Model.Context, Cmd Msg.Msg )
step _ newTime context =
    ( Model.tick newTime context, Cmd.none )
