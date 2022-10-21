module PlayElm.Model exposing
    ( BootingModel
    , Model(..)
    , RunningModel
    , changeProgram
    , defaultModel
    , programs
    )

import Dict
import PlayElm.Msg as Msg
import PlayElm.Programs.Balls as Balls
import PlayElm.Programs.Circle as Circle
import PlayElm.Programs.Cube as Cube
import PlayElm.Programs.LineTenPrint as LineTenPrint
import PlayElm.Programs.LineTenPrintUpdate as LineTenPrintUpdate
import PlayElm.Programs.Plasma as Plasma
import PlayElm.Programs.Update as Update
import PlayElm.Types as Types


type Model
    = Booting BootingModel
    | Running RunningModel
    | Executing RunningModel


type alias BootingModel =
    Types.CommonProperties
        { clientRect : Maybe Types.BoundingClientRect
        , computedStyle : Maybe Types.ComputedStyle
        }


type alias RunningModel =
    { context : Types.Context
    , config : Types.Config Msg.Msg
    , programs : Dict.Dict String (Types.ProgramConfig Msg.Msg)
    , programName : String
    }


standardUpdate : Types.Config Msg.Msg
standardUpdate =
    { updateWithMsg = Update.updateWithMsg
    , step = Update.step
    }


programs : Dict.Dict String (Types.ProgramConfig Msg.Msg)
programs =
    Dict.fromList
        [ ( "Balls"
          , { config = standardUpdate
            , doers =
                { runner = Balls.run
                , generator = LineTenPrint.generateMaze
                , generatedValue = ""
                }
            }
          )
        , ( "Circle"
          , { config = standardUpdate
            , doers =
                { runner = Circle.run
                , generator = LineTenPrint.generateMaze
                , generatedValue = ""
                }
            }
          )
        , ( "Cube"
          , { config = standardUpdate
            , doers =
                { runner = Cube.run
                , generator = LineTenPrint.generateMaze
                , generatedValue = ""
                }
            }
          )
        , ( "Plasma"
          , { config = standardUpdate
            , doers =
                { runner = Plasma.run
                , generator = LineTenPrint.generateMaze
                , generatedValue = ""
                }
            }
          )
        , ( "LineTenPrint"
          , { config =
                { updateWithMsg = LineTenPrintUpdate.updateWithMsg
                , step = LineTenPrintUpdate.step
                }
            , doers =
                { runner = Types.idRunner
                , generator = LineTenPrint.generateMaze
                , generatedValue = ""
                }
            }
          )
        ]


changeProgram : RunningModel -> Types.ProgramConfig Msg.Msg -> String -> RunningModel
changeProgram rm p programName =
    let
        getContext =
            rm.context

        newContext =
            { getContext | doers = p.doers, running = True }
    in
    { rm | config = p.config, context = newContext, programName = programName }


defaultModel : BootingModel
defaultModel =
    { pointer = ( 0, 0 )
    , pressed = False
    , time = 0.0
    , clientRect = Nothing
    , computedStyle = Nothing
    }
