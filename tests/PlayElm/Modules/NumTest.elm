module PlayElm.Modules.NumTest exposing (tests)

import Expect
import PlayElm.Modules.Num as Num
import Test


tests : Test.Test
tests =
    Test.describe "Num Tests"
        [ testMap
        , testSmoothStep
        ]


testMap : Test.Test
testMap =
    Test.describe "Test map"
        [ Test.test "Simple 1" <|
            \_ ->
                Num.map 0.5 0.25 0.1 0.3 0.6 |> Expect.within (Expect.Absolute 0.0001) -0.2
        , Test.test "Simple 2" <|
            \_ ->
                Num.map 0.9 0.5 0.1 0.5 0.9 |> Expect.within (Expect.Absolute 0.0001) 0.09999999999999998
        , Test.test "Simple 3" <|
            \_ ->
                Num.map 0.1 0.2 0.3333333333333333 0.5 0.7 |> Expect.within (Expect.Absolute 0.0001) 0.35
        , Test.test "Simple 4" <|
            \_ ->
                Num.map 55.72786381269883 0.0 69 0.001 0.1 |> Expect.within (Expect.Absolute 0.0001) 0.08095736981822006
        , Test.test "Simple 5" <|
            \_ ->
                Num.map 17.0 0.0 18 -100 -5 |> Expect.within (Expect.Absolute 0.0001) -10.277777777777786
        ]


testSmoothStep : Test.Test
testSmoothStep =
    Test.describe "Test smoothstep"
        [ Test.test "Simple 1" <|
            \_ ->
                Num.smoothstep 0.1 1.2 0.5 |> Expect.within (Expect.Absolute 0.0001) 0.3005259203606312
        , Test.test "Simple 2" <|
            \_ ->
                Num.smoothstep -0.1 4 0.1 |> Expect.within (Expect.Absolute 0.0001) 0.0069064581187156335
        ]
