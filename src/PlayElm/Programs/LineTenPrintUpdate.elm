module PlayElm.Programs.LineTenPrintUpdate exposing (step, updateWithMsg)

import Array
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Types as Types
import Random
import String.Extra as StringExtra


step : Float -> Types.Context -> ( Types.Context, Cmd Msg.Msg )
step newTime context =
    ( context, Random.generate Msg.RandomString (context.doers.generator (context.cols * context.rows)) )


updateWithMsg : Types.Context -> ( Types.Context, Cmd Msg.Msg )
updateWithMsg context =
    let
        newScreen =
            StringExtra.break context.cols context.doers.generatedValue |> Array.fromList

        newRm =
            { context | screen = newScreen, running = False }
    in
    ( newRm, Port.getBoundingClientRect Types.elementId )
