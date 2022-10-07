module PlayElm.Programs.BallsTest exposing (tests)

import Expect
import PlayElm.Modules.Vec2 as Vec2
import Test
import PlayElm.Programs.Balls as Balls
import UtilTest as UtilTest


tests : Test.Test
tests =
    Test.describe "Balls Tests"
        [ testTransform
        ]


testTransform : Test.Test
testTransform =
    Test.describe "Test Transform"
        [ Test.test "Simple" <|
            \_ ->
                let
                    result =
                            Balls.transform (-1.4457356770833332, -1 ) (1.1996456474231054, -0.5829497715100532) 113.077112
                in
                UtilTest.expectTupleWithin (Expect.Absolute 0.0001) (-2.6364067216107436, -0.4704602463297488) result
        ]
