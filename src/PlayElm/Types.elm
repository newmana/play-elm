module PlayElm.Types exposing
    ( BoundingClientRect
    , CommonProperties
    , ComputedStyle
    , Config
    , Context
    , Cursor
    , ProgramConfig
    , Runnable
    , SideEffects
    , cursor
    , elementId
    , tick
    )

import Array
import Random


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
        , pressed : Bool
        , time : Float
    }


tick : Float -> CommonProperties a -> CommonProperties a
tick delta anyM =
    { anyM | time = anyM.time + delta }


type alias Cursor =
    { x : Float
    , y : Float
    , pressed : Bool
    }


cursor : Context -> Cursor
cursor context =
    { x = min (context.cols - 1 |> toFloat) ((context.pointer |> Tuple.first) / context.computedStyle.cellWidth)
    , y = min (context.rows - 1 |> toFloat) ((context.pointer |> Tuple.second) / context.computedStyle.lineHeight)
    , pressed = context.pressed
    }


type alias Context =
    CommonProperties
        { clientRect : BoundingClientRect
        , computedStyle : ComputedStyle
        , aspect : Float
        , cols : Int
        , rows : Int
        , resized : Bool
        , buffer : Array.Array Int
        , screen : Array.Array String
        , running : Bool
        , effects : SideEffects
        }


type alias Runnable =
    Context -> Context


idRunner : Runnable
idRunner context =
    context


type alias Config a =
    { execute : Runnable -> Context -> ( Context, Cmd a )
    , fetch : Float -> Context -> ( Context, Cmd a )
    }


type alias SideEffects =
    { stringGenerator : Int -> Random.Generator String
    , intGenerator : Int -> Random.Generator (List Int)
    , floatGenerator : Int -> Random.Generator (List Float)
    , generatedString : String
    , generatedInts : List Int
    , generatedFloats : List Float
    }


type alias ProgramConfig a =
    { config : Config a
    , runner : Runnable
    , effects : SideEffects
    }
