module PlayElm.Modules.NumTest exposing (tests)

import Expect
import PlayElm.Modules.Num as Num
import Test


tests : Test.Test
tests =
    Test.describe "Num Tests"
        [ testMap
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
        ]
