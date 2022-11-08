module PlayElm.Programs.Generator exposing
    ( floatGenerator
    , floatToInt
    , intGenerator
    , noFloatGenerator
    , noIntGenerator
    , noStringGenerator
    )

import Random
import Random.Char as RandomChar
import Random.Float as RandomFloat
import Random.Int as RandomInt
import Random.String as RandomString


noStringGenerator : Int -> Random.Generator String
noStringGenerator _ =
    RandomString.string 0 RandomChar.english


noIntGenerator : Int -> Int -> Int -> Random.Generator (List Int)
noIntGenerator _ _ _ =
    intGenerator 0 0 1


noFloatGenerator : Int -> Float -> Float -> Random.Generator (List Float)
noFloatGenerator _ _ _ =
    floatGenerator 0 0.0 1.0


intGenerator : Int -> Int -> Int -> Random.Generator (List Int)
intGenerator length min max =
    Random.list length (Random.int min max)


floatGenerator : Int -> Float -> Float -> Random.Generator (List Float)
floatGenerator length min max =
    Random.list length (Random.float min max)


floatToInt : Float -> Int -> Int -> Int
floatToInt f min max =
    let
        ( a, b ) =
            if min > max then
                ( max |> toFloat, min |> toFloat )

            else
                ( min |> toFloat, max |> toFloat )
    in
    floor (a + f * (b - a + 1))
