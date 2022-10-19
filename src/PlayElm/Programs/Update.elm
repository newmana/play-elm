module PlayElm.Programs.Update exposing (..)

import Array as Array
import PlayElm.Modules.Sdf as Sdf
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Programs.Balls as Balls
import PlayElm.Types as Types


step : Float -> Types.Context -> ( Types.Context, Cmd Msg.Msg )
step newTime context =
    ( Types.tick newTime context, Cmd.none )


updateWithMsg : Types.Context -> ( Types.Context, Cmd Msg.Msg )
updateWithMsg context =
    let
        commonContext =
            context.doers.runner
                { pointer = context.pointer
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
