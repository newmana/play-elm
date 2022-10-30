module PlayElm.Programs.GeneratorTest exposing (tests)

import Expect
import PlayElm.Programs.Generator as Generator
import Test
import UtilTest


tests : Test.Test
tests =
    Test.describe "Generator Tests"
        [ testTransform
        ]


testTransform : Test.Test
testTransform =
    Test.describe "Test FloatToInt"
        [ Test.test "Simple" <|
            \_ ->
                Generator.floatToInt 0.5 1 3 |> Expect.equal 2
        , Test.test "Simple with offset" <|
            \_ ->
                Generator.floatToInt 0.5 5 50 |> Expect.equal 28
        ]
