module UtilTest exposing (expectTripleWithin, expectTupleWithin)

import Expect


expectTupleWithin : Expect.FloatingPointTolerance -> ( Float, Float ) -> ( Float, Float ) -> Expect.Expectation
expectTupleWithin tolerance ( expectedFirst, expectedSecond ) actual =
    let
        expectFirst =
            Expect.within tolerance expectedFirst << Tuple.first

        expectSecond =
            Expect.within tolerance expectedSecond << Tuple.second
    in
    Expect.all [ expectFirst, expectSecond ] actual


expectTripleWithin : Expect.FloatingPointTolerance -> ( Float, Float, Float ) -> ( Float, Float, Float ) -> Expect.Expectation
expectTripleWithin tolerance ( expectedFirst, expectedSecond, expectedThird ) actual =
    let
        expectFirst =
            Expect.within tolerance expectedFirst << (\( x, _, _ ) -> x)

        expectSecond =
            Expect.within tolerance expectedSecond << (\( _, y, _ ) -> y)

        expectThird =
            Expect.within tolerance expectedThird << (\( _, _, z ) -> z)
    in
    Expect.all [ expectFirst, expectSecond, expectThird ] actual
