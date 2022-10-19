module PlayElm.Types exposing (BoundingClientRect, CommonContext, CommonProperties, ComputedStyle, Context, Doers, Runnable)

import Array as Array
import Random as Random
import Time as Time


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


type alias Doers =
    { runner : Runnable
    , generator : Int -> Random.Generator String
    , generatedValue : String
    }
