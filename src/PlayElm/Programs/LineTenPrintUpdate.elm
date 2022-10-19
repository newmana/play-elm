module PlayElm.Programs.LineTenPrintUpdate exposing (..)

import Array as Array
import PlayElm.Model as Model
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Programs.LineTenPrint as LineTenPrint
import PlayElm.Types as Types
import Random as Random


step : Float -> Types.Context -> ( Types.Context, Cmd Msg.Msg )
step newTime context =
    ( context, Random.generate Msg.RandomString (context.doers.generator (context.cols * context.rows)) )


updateWithMsg : Types.Context -> ( Types.Context, Cmd Msg.Msg )
updateWithMsg context =
    let
        newScreen =
            Array.push context.doers.generatedValue context.screen

        newRm =
            { context | screen = newScreen }
    in
    ( newRm, Port.getBoundingClientRect Model.elementId )
