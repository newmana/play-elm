module PlayElm.Model exposing
    ( BootingModel
    , CommonProperties
    , Model(..)
    , RunningModel
    , defaultModel
    , elementId
    )

import Browser.Navigation as BrowserNavigation
import PlayElm.Types as Types
import Time as Time


elementId : String
elementId =
    "play"


type alias CommonProperties a =
    { a
        | pointer : ( Float, Float )
        , time : Time.Posix
    }


type Model
    = Booting BootingModel
    | Running RunningModel


type alias BootingModel =
    CommonProperties
        { clientRect : Maybe Types.BoundingClientRect
        , computedStyle : Maybe Types.ComputedStyle
        }


type alias RunningModel =
    CommonProperties
        { clientRect : Types.BoundingClientRect
        , computedStyle : Types.ComputedStyle
        , aspect : Float
        , cols : Int
        , rows : Int
        , screen : List String
        }


defaultModel : BootingModel
defaultModel =
    { pointer = ( 0, 0 )
    , time = Time.millisToPosix 0
    , clientRect = Nothing
    , computedStyle = Nothing
    }
