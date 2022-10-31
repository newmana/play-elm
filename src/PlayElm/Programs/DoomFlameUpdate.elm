module PlayElm.Programs.DoomFlameUpdate exposing (execute, fetch)

import Array
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Programs.DoomFlame as DoomFlame
import PlayElm.Types as Types
import Random
import String.Extra as StringExtra


fetch : Float -> Types.Context -> ( Types.Context, Cmd Msg.Msg )
fetch _ context =
    let
        dataRndNumbers =
            context.cols * context.rows * 2

        noiseRndNumbers =
            DoomFlame.tableSize * 2
    in
    ( context, Random.generate Msg.RandomFloats (context.effects.floatGenerator (noiseRndNumbers + 1 + dataRndNumbers)) )


execute : Types.Runnable -> Types.Context -> ( Types.Context, Cmd Msg.Msg )
execute runner context =
    let
        newScreen =
            StringExtra.break context.cols context.effects.generatedString |> Array.fromList

        newRm =
            { context | screen = newScreen, running = False }
    in
    ( newRm, Port.getBoundingClientRect Types.elementId )
