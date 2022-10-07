module UtilTest exposing (expectTupleWithin)

import Expect

expectTupleWithin : Expect.FloatingPointTolerance -> (Float, Float) -> (Float, Float) -> Expect.Expectation
expectTupleWithin tolerance (expectedFirst, expectedSecond) actual =
    let
        expectFirst a = Tuple.first a |> Expect.within tolerance expectedFirst

        expectSecond a = Tuple.second a |>  Expect.within tolerance expectedSecond
    in
    Expect.all [expectFirst, expectSecond] actual