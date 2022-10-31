module PlayElm.Programs.Update exposing (execute, fetch)

import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Types as Types


fetch : Float -> Types.Context -> ( Types.Context, Cmd Msg.Msg )
fetch newTime context =
    ( Types.tick newTime context, Cmd.none )


execute : Types.Runnable -> Types.Context -> ( Types.Context, Cmd Msg.Msg )
execute runner context =
    let
        contextResult =
            runner
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
                , doers = context.doers
                }

        newContext =
            { pointer = contextResult.pointer
            , pressed = contextResult.pressed
            , time = contextResult.time
            , clientRect = contextResult.clientRect
            , computedStyle = contextResult.computedStyle
            , aspect = contextResult.aspect
            , cols = contextResult.cols
            , rows = contextResult.rows
            , screen = contextResult.screen
            , running = contextResult.running
            , doers = context.doers
            }
    in
    ( newContext, Port.getBoundingClientRect Types.elementId )
