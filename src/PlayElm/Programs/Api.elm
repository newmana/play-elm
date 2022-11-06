module PlayElm.Programs.Api exposing
    ( defaultProgram
    , programs
    , withConfig
    , withFloatGenerator
    , withIntGenerator
    , withStringGenerator
    )

import Dict
import PlayElm.Msg as Msg
import PlayElm.Programs.Balls as Balls
import PlayElm.Programs.Circle as Circle
import PlayElm.Programs.Cube as Cube
import PlayElm.Programs.DoomFlame as DoomFlame
import PlayElm.Programs.DoomFlameUpdate as DoomFlameUpdate
import PlayElm.Programs.Generator as Generator
import PlayElm.Programs.LineTenPrint as LineTenPrint
import PlayElm.Programs.LineTenPrintUpdate as LineTenPrintUpdate
import PlayElm.Programs.Plasma as Plasma
import PlayElm.Programs.Update as Update
import PlayElm.Types as Types
import Random


standardUpdate : Types.Config Msg.Msg
standardUpdate =
    { execute = Update.execute
    , fetch = Update.fetch
    }


defaultProgram : Types.Runnable -> Types.ProgramConfig Msg.Msg
defaultProgram runner =
    { config = standardUpdate
    , runner = runner
    , effects =
        { stringGenerator = Generator.noStringGenerator
        , intGenerator = Generator.noIntGenerator
        , floatGenerator = Generator.noFloatGenerator
        , generatedString = ""
        , generatedInts = []
        , generatedFloats = []
        }
    }


withConfig : Types.Config Msg.Msg -> Types.ProgramConfig Msg.Msg -> Types.ProgramConfig Msg.Msg
withConfig c pc =
    { pc | config = c }


withStringGenerator : (Int -> Random.Generator String) -> Types.ProgramConfig Msg.Msg -> Types.ProgramConfig Msg.Msg
withStringGenerator sg pc =
    let
        getDoers =
            pc.effects

        newDoers =
            { getDoers | stringGenerator = sg }
    in
    { pc | effects = newDoers }


withIntGenerator : (Int -> Random.Generator (List Int)) -> Types.ProgramConfig Msg.Msg -> Types.ProgramConfig Msg.Msg
withIntGenerator ig pc =
    let
        getDoers =
            pc.effects

        newDoers =
            { getDoers | intGenerator = ig }
    in
    { pc | effects = newDoers }


withFloatGenerator : (Int -> Random.Generator (List Float)) -> Types.ProgramConfig Msg.Msg -> Types.ProgramConfig Msg.Msg
withFloatGenerator fg pc =
    let
        getDoers =
            pc.effects

        newDoers =
            { getDoers | floatGenerator = fg }
    in
    { pc | effects = newDoers }


programs : Dict.Dict String (Types.ProgramConfig Msg.Msg)
programs =
    Dict.fromList
        [ ( "Balls"
          , defaultProgram Balls.run
          )
        , ( "Circle"
          , defaultProgram Circle.run
          )
        , ( "Cube"
          , defaultProgram Cube.run
          )
        , ( "Doom Flame"
          , defaultProgram DoomFlame.run
                |> withConfig
                    { execute = DoomFlameUpdate.execute
                    , fetch = DoomFlameUpdate.fetch
                    }
                |> withIntGenerator Generator.intGenerator
                |> withFloatGenerator Generator.floatGenerator
          )
        , ( "Plasma"
          , defaultProgram Plasma.run
          )
        , ( "LineTenPrint"
          , defaultProgram identity
                |> withConfig
                    { execute = LineTenPrintUpdate.execute
                    , fetch = LineTenPrintUpdate.fetch
                    }
                |> withStringGenerator LineTenPrint.generateMaze
          )
        ]
