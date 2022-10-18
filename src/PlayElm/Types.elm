module PlayElm.Types exposing (BoundingClientRect, ComputedStyle, Config, Context, Runnable)

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


type alias Context =
    { time : Float
    , cols : Int
    , rows : Int
    , width : Float
    , height : Float
    , aspect : Float
    }


type alias Runnable =
    Context -> Int -> Int -> String


type alias Config =
    { runner : Runnable
    }
