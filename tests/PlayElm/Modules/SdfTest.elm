module PlayElm.Modules.SdfTest exposing (tests)

import Expect
import PlayElm.Modules.Sdf as Sdf
import Test


tests : Test.Test
tests =
    Test.describe "Sdf Tests"
        [ testSdCircle
        , testSdSegment
        ]


testSdCircle : Test.Test
testSdCircle =
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


testSdSegment : Test.Test
testSdSegment =
    Test.describe "Test sdSegment"
        [ Test.test "Simple 1" <|
            \_ ->
                Sdf.sdSegment
                    ( -1.4247829861111112, -0.9523809523809523 )
                    ( 0.123238232015712, -0.3817221278359254 )
                    ( 0.47166415594179545, -0.17962459785036353 )
                    0.0069519851121956746
                    |> Expect.within (Expect.Absolute 0.0001) 1.6429029132961355
        , Test.test "Simple 2" <|
            \_ ->
                Sdf.sdSegment
                    ( -0.17111364293981482, -0.5 )
                    ( 0.26491842197777526, -0.23455323517639456 )
                    ( 0.008936963441312791, -0.07872924750956867 )
                    0.07404635006861487
                    |> Expect.within (Expect.Absolute 0.0001) 0.3794175727966328
        ]
