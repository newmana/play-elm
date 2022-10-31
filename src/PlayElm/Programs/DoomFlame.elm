module PlayElm.Programs.DoomFlame exposing (run, tableSize)

import Array
import PlayElm.Modules.Num as Num
import PlayElm.Modules.Sdf as Sdf
import PlayElm.Types as Types


chars : String
chars =
    "...::/\\/\\/\\+=*abcdef01XYZ#"


tableSize =
    256


run : Types.Runnable
run context =
    let
        t =
            context.time * 0.0015

        row rowNum =
            List.foldl (\colNum str -> str ++ runLine context colNum rowNum) "" (List.range 0 (context.cols - 1))

        newScreen =
            List.foldl (\rowNum -> Array.push (row rowNum)) Array.empty (List.range 0 (context.rows - 1))
    in
    { context | screen = newScreen }


runLine : Types.Context -> Int -> Int -> String
runLine context x y =
    let
        t =
            context.time * 0.001 + 10

        m =
            min context.cols context.rows |> toFloat

        a =
            context.aspect

        stX =
            2.0 * (toFloat x - toFloat context.cols / 2.0) / m * a

        stY =
            2.0 * (toFloat y - toFloat context.rows / 2.0) / m

        s =
            Num.map (sin (t * 0.5)) -1 1 0.0 0.9

        dR num i =
            Num.map (cos (t * 0.95 * (i + 1) / (num + 1))) -1 1 0.1 0.3

        dX num i =
            Num.map (cos (t * 0.23 * (i / num * pi + pi))) -1 1 -1.2 1.2

        dY num i =
            Num.map (sin (t * 0.37 * (i / num * pi + pi))) -1 1 -1.2 1.2

        dF num i =
            ( 1.0, 1.0 )

        maxNum =
            12

        calc fIndex currentD =
            Sdf.opSmoothUnion currentD (Sdf.sdCircle (dF maxNum fIndex) (dR maxNum fIndex)) s

        d =
            List.foldl
                (\index currentD -> calc (toFloat index) currentD)
                1.0e100
                (List.range 0 (maxNum - 1))

        c =
            1.0 - (e ^ (-3 * abs d))

        charsIndex =
            floor (c * (String.length chars |> toFloat))
    in
    String.slice charsIndex (charsIndex + 1) chars


valueNoise : Array.Array Float -> Array.Array Float -> Float -> Float -> Float
valueNoise r permutationRnd px py =
    let
        permutationTableInit =
            Array.initialize (tableSize * 2)
                (\i ->
                    if i < tableSize then
                        i

                    else
                        0
                )

        permutationTable =
            List.foldl
                (\k acc ->
                    let
                        i =
                            Array.get k permutationRnd |> Maybe.map (\x -> x * tableSize) |> Maybe.withDefault 0 |> floor

                        permI =
                            Array.get i acc |> Maybe.withDefault 0

                        permK =
                            Array.get k acc |> Maybe.withDefault 0

                        newK =
                            Array.set k permI acc

                        newI =
                            Array.set i permK newK

                        newNewK =
                            Array.get k newI |> Maybe.withDefault 0

                        newKTableSize =
                            Array.set (k + tableSize) newNewK newI
                    in
                    newKTableSize
                )
                permutationTableInit
                (List.range 0 tableSize)

        xi =
            floor px

        yi =
            floor py

        tx =
            px - (xi |> toFloat)

        ty =
            py - (yi |> toFloat)

        rx0 =
            modBy tableSize xi

        rx1 =
            modBy tableSize (rx0 + 1)

        ry0 =
            modBy tableSize yi

        ry1 =
            modBy tableSize (ry0 + 1)

        c00 =
            Array.get rx0 permutationTable
                |> Maybe.withDefault 0
                |> (\x -> x + ry0)
                |> (\xx -> Array.get xx permutationTable)
                |> Maybe.withDefault 0
                |> (\xxx -> Array.get xxx r)
                |> Maybe.withDefault 0

        c10 =
            Array.get rx1 permutationTable
                |> Maybe.withDefault 0
                |> (\x -> x + ry0)
                |> (\xx -> Array.get xx permutationTable)
                |> Maybe.withDefault 0
                |> (\xxx -> Array.get xxx r)
                |> Maybe.withDefault 0

        c01 =
            Array.get rx0 permutationTable
                |> Maybe.withDefault 0
                |> (\x -> x + ry1)
                |> (\xx -> Array.get xx permutationTable)
                |> Maybe.withDefault 0
                |> (\xxx -> Array.get xxx r)
                |> Maybe.withDefault 0

        c11 =
            Array.get rx1 permutationTable
                |> Maybe.withDefault 0
                |> (\x -> x + ry1)
                |> (\xx -> Array.get xx permutationTable)
                |> Maybe.withDefault 0
                |> (\xxx -> Array.get xxx r)
                |> Maybe.withDefault 0

        sx =
            Num.smoothstep 0 1 tx

        sy =
            Num.smoothstep 0 1 ty

        nx0 =
            Num.mix c00 c10 sx

        nx1 =
            Num.mix c01 c11 sx
    in
    Num.mix nx0 nx1 sy
