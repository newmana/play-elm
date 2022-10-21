module PlayElm.Modules.Vec3Test exposing (tests)

import Expect
import PlayElm.Modules.Vec3 as Vec3
import Test
import UtilTest as UtilTest


tests : Test.Test
tests =
    Test.describe "3D Vector Tests"
        [ testRotX
        , testRotY
        , testRotZ
        ]


testRotX : Test.Test
testRotX =
    Test.describe "Test rotX"
        [ Test.test "Simple" <|
            \_ ->
                Vec3.rotX ( 0.6, 0.6, 0.6 ) 880.8610217
                    |> UtilTest.expectTripleWithin (Expect.Absolute 0.0001)
                        ( 0.6, -0.35348018682692933, 0.7713959797152168 )
        ]


testRotY : Test.Test
testRotY =
    Test.describe "Test rotY"
        [ Test.test "Simple" <|
            \_ ->
                Vec3.rotY ( 0.6, -0.35348018682692933, 0.7713959797152168 ) 1041.0175711000002
                    |> UtilTest.expectTripleWithin (Expect.Absolute 0.0001)
                        ( -0.9491011581140854, -0.35348018682692933, 0.23293507504732114 )
        ]


testRotZ : Test.Test
testRotZ =
    Test.describe "Test rotZ"
        [ Test.test "Simple" <|
            \_ ->
                Vec3.rotZ ( -0.9491011581140854, -0.35348018682692933, 0.23293507504732114 ) -1201.1741205
                    |> UtilTest.expectTripleWithin (Expect.Absolute 0.0001)
                        ( -0.7552408591750945
                        , 0.6747981145832908
                        , 0.23293507504732114
                        )
        ]
