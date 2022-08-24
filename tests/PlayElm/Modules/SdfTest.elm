module PlayElm.Modules.SdfTest exposing (tests)

import Expect
import PlayElm.Modules.Sdf as Sdf
import Test


tests : Test.Test
tests =
    Test.describe "Sdf Tests"
        [ testCircle
        ]


testCircle : Test.Test
testCircle =
    Test.describe "Test sdCircle"
        [ Test.test "Simple positive" <|
            \_ ->
                Sdf.sdCircle ( 2, 2 ) 2 |> Expect.within (Expect.Absolute 0.0001) 0.8284271247461903
        , Test.test "Simple mixed" <|
            \_ ->
                Sdf.sdCircle ( -2, 2 ) 2 |> Expect.within (Expect.Absolute 0.0001) 0.8284271247461903
        , Test.test "Simple negative" <|
            \_ ->
                Sdf.sdCircle ( -2, -2 ) 2 |> Expect.within (Expect.Absolute 0.0001) 0.8284271247461903
        ]
