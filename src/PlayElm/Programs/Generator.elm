module PlayElm.Programs.Generator exposing
    ( floatGenerator
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


noIntGenerator : Int -> Random.Generator (List Int)
noIntGenerator _ =
    Random.list 0 RandomInt.anyInt


noFloatGenerator : Int -> Random.Generator (List Float)
noFloatGenerator _ =
    Random.list 0 RandomFloat.anyFloat


intGenerator : Int -> Random.Generator (List Int)
intGenerator length =
    Random.list length RandomInt.anyInt


floatGenerator : Int -> Random.Generator (List Float)
floatGenerator length =
    Random.list length RandomFloat.anyFloat
