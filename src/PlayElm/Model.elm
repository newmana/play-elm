module PlayElm.Model exposing
    ( BootingModel
    , CommonProperties
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
        , screen : Array.Array String
        , running : Bool
        }


defaultModel : BootingModel
defaultModel =
    { pointer = ( 0, 0 )
    , time = 0.0
    , clientRect = Nothing
    , computedStyle = Nothing
    }


tick : Float -> Model -> Model
tick delta m =
    let
        updateTime anyM =
            { anyM | time = anyM.time + delta }
    in
    case m of
        Booting bm ->
            updateTime bm |> Booting

        Running rm ->
            updateTime rm |> Running
