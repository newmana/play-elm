module PlayElm.Model exposing
    ( BootingModel
    , CommonProperties
    , Model(..)
    , RunningModel
    , defaultModel
    , elementId
    )

import Array as Array
import Browser.Navigation as BrowserNavigation
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


type alias BootingModel =
    CommonProperties
        { clientRect : Maybe Types.BoundingClientRect
        , computedStyle : Maybe Types.ComputedStyle
        , startTime : Maybe Float
        }


type alias RunningModel =
    CommonProperties
        { clientRect : Types.BoundingClientRect
        , computedStyle : Types.ComputedStyle
        , startTime : Float
        , aspect : Float
        , cols : Int
        , rows : Int
        , screen : Array.Array String
        }


defaultModel : BootingModel
defaultModel =
    { pointer = ( 0, 0 )
    , time = 0.0
    , clientRect = Nothing
    , computedStyle = Nothing
    , startTime = Nothing
    }
