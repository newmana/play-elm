module PlayElm.Programs.LineTenPrintUpdate exposing (..)

import Array as Array
import PlayElm.Model as Model
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Programs.LineTenPrint as LineTenPrint
import PlayElm.Types as Types
import Random as Random


step : Types.Doers -> Float -> Types.Context -> ( Types.Context, Cmd Msg.Msg )
step doers newTime context =
    ( context, Random.generate Msg.RandomString (doers.generator (context.cols * context.rows)) )


updateWithMsg : Types.Doers -> Types.Context -> ( Types.Context, Cmd Msg.Msg )
updateWithMsg doers context =
    let
        newScreen =
            Array.push doers.generatedValue context.screen

        newRm =
            { context | screen = newScreen }
    in
    ( newRm, Port.getBoundingClientRect Model.elementId )
