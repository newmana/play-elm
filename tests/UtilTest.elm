module UtilTest exposing (expectTupleWithin)

import Expect


expectTupleWithin : Expect.FloatingPointTolerance -> ( Float, Float ) -> ( Float, Float ) -> Expect.Expectation
expectTupleWithin tolerance ( expectedFirst, expectedSecond ) actual =
    let
        expectFirst =
            Expect.within tolerance expectedFirst << Tuple.first

        expectSecond a =
            Expect.within tolerance expectedSecond << Tuple.second
    in
    Expect.all [ expectFirst, expectSecond ] actual
