module PlayElm.Programs.Update exposing (execute, fetch)

import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Types as Types


fetch : Float -> Types.Context -> ( Types.Context, Cmd Msg.Msg )
fetch newTime context =
    ( Types.tick newTime context, Cmd.none )


execute : Types.Runnable -> Types.Context -> ( Types.Context, Cmd Msg.Msg )
execute runner context =
    ( runner context, Port.getBoundingClientRect Types.elementId )
