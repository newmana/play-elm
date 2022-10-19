module PlayElm.Model exposing
    ( BootingModel
    , CommonProperties
    , Config
    , Context
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


type alias CommonProperties a =
    { a
        | pointer : ( Float, Float )
        , time : Float
    }


type Model
    = Booting BootingModel
    | Running RunningModel
    | Executing RunningModel


type alias BootingModel =
    CommonProperties
        { clientRect : Maybe Types.BoundingClientRect
        , computedStyle : Maybe Types.ComputedStyle
        }


type alias RunningModel =
    { context : Context
    , config : Config Types.Doers Msg.Msg
    }


type alias Context =
    CommonProperties
        { clientRect : Types.BoundingClientRect
        , computedStyle : Types.ComputedStyle
        , aspect : Float
        , cols : Int
        , rows : Int
        , screen : Array.Array String
        , running : Bool
        , doers : Types.Doers
        }


type alias Config a b =
    { updateWithMsg : a -> Context -> ( Context, Cmd b )
    , step : a -> Float -> Context -> ( Context, Cmd b )
    }


defaultModel : BootingModel
defaultModel =
    { pointer = ( 0, 0 )
    , time = 0.0
    , clientRect = Nothing
    , computedStyle = Nothing
    }


tick : Float -> CommonProperties a -> CommonProperties a
tick delta anyM =
    { anyM | time = anyM.time + delta }
