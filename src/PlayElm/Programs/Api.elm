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
    , doers =
        { runner = runner
        , stringGenerator = Generator.noStringGenerator
        , intGenerator = Generator.noIntGenerator
        , floatGenerator = Generator.noFloatGenerator
        , generatedValue = ""
        }
    }


withConfig : Types.Config Msg.Msg -> Types.ProgramConfig Msg.Msg -> Types.ProgramConfig Msg.Msg
withConfig c pc =
    { pc | config = c }


withStringGenerator : (Int -> Random.Generator String) -> Types.ProgramConfig Msg.Msg -> Types.ProgramConfig Msg.Msg
withStringGenerator sg pc =
    let
        getDoers =
            pc.doers

        newDoers =
            { getDoers | stringGenerator = sg }
    in
    { pc | doers = newDoers }


withIntGenerator : (Int -> Random.Generator (List Int)) -> Types.ProgramConfig Msg.Msg -> Types.ProgramConfig Msg.Msg
withIntGenerator ig pc =
    let
        getDoers =
            pc.doers

        newDoers =
            { getDoers | intGenerator = ig }
    in
    { pc | doers = newDoers }


withFloatGenerator : (Int -> Random.Generator (List Float)) -> Types.ProgramConfig Msg.Msg -> Types.ProgramConfig Msg.Msg
withFloatGenerator fg pc =
    let
        getDoers =
            pc.doers

        newDoers =
            { getDoers | floatGenerator = fg }
    in
    { pc | doers = newDoers }


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
        , ( "Plasma"
          , defaultProgram Plasma.run
          )
        , ( "LineTenPrint"
          , defaultProgram Types.idRunner
                |> withConfig
                    { execute = LineTenPrintUpdate.execute
                    , fetch = LineTenPrintUpdate.fetch
                    }
                |> withStringGenerator LineTenPrint.generateMaze
          )
        ]
