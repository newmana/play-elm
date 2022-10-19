module PlayElm.Types exposing
    ( BoundingClientRect
    , CommonContext
    , CommonProperties
    , ComputedStyle
    , Config
    , Context
    , Doers
    , ProgramConfig
    , Runnable
    , elementId
    , idRunner
    , tick
    )

import Array as Array
import Random as Random
import Time as Time


elementId : String
elementId =
    "play"


type alias BoundingClientRect =
    { left : Float
    , top : Float
    , right : Float
    , bottom : Float
    , x : Float
    , y : Float
    , width : Float
    , height : Float
    }


type alias ComputedStyle =
    { fontFamily : String
    , fontSize : Float
    , lineHeight : Float
    , cellWidth : Float
    }


type alias CommonProperties a =
    { a
        | pointer : ( Float, Float )
        , time : Float
    }


tick : Float -> CommonProperties a -> CommonProperties a
tick delta anyM =
    { anyM | time = anyM.time + delta }


type alias CommonContext a =
    CommonProperties
        { a
            | clientRect : BoundingClientRect
            , computedStyle : ComputedStyle
            , aspect : Float
            , cols : Int
            , rows : Int
            , screen : Array.Array String
            , running : Bool
        }


type alias Context =
    CommonContext
        { doers : Doers
        }


type alias Runnable =
    CommonContext {} -> CommonContext {}


idRunner : Runnable
idRunner context =
    context


type alias Doers =
    { runner : Runnable
    , generator : Int -> Random.Generator String
    , generatedValue : String
    }


type alias Config a =
    { updateWithMsg : Context -> ( Context, Cmd a )
    , step : Float -> Context -> ( Context, Cmd a )
    }


type alias ProgramConfig a =
    { config : Config a
    , doers : Doers
    }
