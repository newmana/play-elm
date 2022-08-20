module PlayElm.Model exposing
    ( Model
    , defaultModel
    , elementId
    )

import Browser.Navigation as BrowserNavigation
import Time as Time


elementId : String
elementId =
    "play"


type alias Model =
    { cols : Int
    , rows : Int
    , widthHeight : ( Float, Float )
    , pointer : ( Float, Float )
    , time : Time.Posix
    }


defaultModel : Model
defaultModel =
    { cols = 0
    , rows = 0
    , widthHeight = ( 0, 0 )
    , pointer = ( 0, 0 )
    , time = Time.millisToPosix 0
    }
