module PlayElm.Model exposing
    ( BootingModel
    , Model(..)
    , RunningModel
    , defaultModel
    , programs
    )

import Array as Array
import Browser.Navigation as BrowserNavigation
import Dict as Dict
import PlayElm.Msg as Msg
import PlayElm.Programs.Balls as Balls
import PlayElm.Programs.Circle as Circle
import PlayElm.Programs.LineTenPrint as LineTenPrint
import PlayElm.Programs.LineTenPrintUpdate as LineTenPrintUpdate
import PlayElm.Programs.Update as Update
import PlayElm.Types as Types
import Time as Time


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


defaultModel : BootingModel
defaultModel =
    { pointer = ( 0, 0 )
    , time = 0.0
    , clientRect = Nothing
    , computedStyle = Nothing
    }
