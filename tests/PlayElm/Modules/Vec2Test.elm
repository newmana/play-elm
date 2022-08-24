module PlayElm.Modules.Vec2Test exposing (tests)

import Expect
import PlayElm.Modules.Vec2 as Vec2
import Test


tests : Test.Test
tests =
    Test.describe "2D Vector Tests"
        [ testLength
        ]


testLength : Test.Test
testLength =
    Test.describe "Test Length"
        [ Test.test "Simple" <|
            \_ ->
                Vec2.length ( 2, 2 ) |> Expect.within (Expect.Absolute 0.0001) 2.8284271247461903
        , Test.test "Mixed" <|
            \_ ->
                Vec2.length ( -2, 2 ) |> Expect.within (Expect.Absolute 0.0001) 2.8284271247461903
        , Test.test "Negative" <|
            \_ ->
                Vec2.length ( -2, -2 ) |> Expect.within (Expect.Absolute 0.0001) 2.8284271247461903
        ]
