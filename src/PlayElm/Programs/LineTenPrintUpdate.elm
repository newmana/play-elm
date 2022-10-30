module PlayElm.Programs.LineTenPrintUpdate exposing (execute, fetch)

import Array
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Types as Types
import Random
import String.Extra as StringExtra


fetch : Float -> Types.Context -> ( Types.Context, Cmd Msg.Msg )
fetch _ context =
    ( context, Random.generate Msg.RandomString (context.doers.stringGenerator (context.cols * context.rows)) )


execute : Types.Context -> ( Types.Context, Cmd Msg.Msg )
execute context =
    let
        newScreen =
            StringExtra.break context.cols context.doers.generatedValue |> Array.fromList

        newRm =
            { context | screen = newScreen, running = False }
    in
    ( newRm, Port.getBoundingClientRect Types.elementId )
