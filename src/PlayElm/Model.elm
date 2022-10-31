module PlayElm.Model exposing
    ( BootingModel
    , Model(..)
    , RunningModel
    , changeProgram
    , defaultModel
    )

import Dict
import PlayElm.Msg as Msg
import PlayElm.Types as Types


type Model
    = Booting BootingModel
    | Fetch RunningModel
    | Executing RunningModel


type alias BootingModel =
    Types.CommonProperties
        { clientRect : Maybe Types.BoundingClientRect
        , computedStyle : Maybe Types.ComputedStyle
        }


type alias RunningModel =
    { context : Types.Context
    , runner : Types.Runnable
    , config : Types.Config Msg.Msg
    , programs : Dict.Dict String (Types.ProgramConfig Msg.Msg)
    , programName : String
    }


defaultModel : BootingModel
defaultModel =
    { pointer = ( 0, 0 )
    , pressed = False
    , time = 0.0
    , clientRect = Nothing
    , computedStyle = Nothing
    }


changeProgram : RunningModel -> Types.ProgramConfig Msg.Msg -> String -> RunningModel
changeProgram rm p programName =
    let
        getContext =
            rm.context

        newContext =
            { getContext | doers = p.effects, running = True }
    in
    { rm
        | runner = p.runner
        , config = p.config
        , context = newContext
        , programName = programName
    }
