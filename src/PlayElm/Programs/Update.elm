module PlayElm.Programs.Update exposing (execute, fetch)

import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Types as Types


fetch : Float -> Types.Context -> ( Types.Context, Cmd Msg.Msg )
fetch newTime context =
    ( Types.tick newTime context, Cmd.none )


execute : Types.Context -> ( Types.Context, Cmd Msg.Msg )
execute context =
    let
        commonContext =
            context.doers.runner
                { pointer = context.pointer
                , pressed = context.pressed
                , time = context.time
                , clientRect = context.clientRect
                , computedStyle = context.computedStyle
                , aspect = context.aspect
                , cols = context.cols
                , rows = context.rows
                , screen = context.screen
                , running = context.running
                }

        newContext =
            { pointer = commonContext.pointer
            , pressed = commonContext.pressed
            , time = commonContext.time
            , clientRect = commonContext.clientRect
            , computedStyle = commonContext.computedStyle
            , aspect = commonContext.aspect
            , cols = commonContext.cols
            , rows = commonContext.rows
            , screen = commonContext.screen
            , running = commonContext.running
            , doers = context.doers
            }
    in
    ( newContext, Port.getBoundingClientRect Types.elementId )
