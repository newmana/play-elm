module PlayElm.Model exposing
    ( BootingModel
    , Config
    , Model(..)
    , RunningModel
    , defaultModel
    , elementId
    , tick
    )

import Array as Array
import Browser.Navigation as BrowserNavigation
import PlayElm.Msg as Msg
import PlayElm.Types as Types
import Time as Time


elementId : String
elementId =
    "play"


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
    , config : Config Types.Doers Msg.Msg
    }


type alias Config a b =
    { updateWithMsg : a -> Types.Context -> ( Types.Context, Cmd b )
    , step : a -> Float -> Types.Context -> ( Types.Context, Cmd b )
    }


defaultModel : BootingModel
defaultModel =
    { pointer = ( 0, 0 )
    , time = 0.0
    , clientRect = Nothing
    , computedStyle = Nothing
    }


tick : Float -> Types.CommonProperties a -> Types.CommonProperties a
tick delta anyM =
    { anyM | time = anyM.time + delta }
