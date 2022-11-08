module PlayElm.Programs.DoomFlame exposing (run, tableSize)

import Array
import List.Extra as ListExtra
import PlayElm.Modules.Num as Num
import PlayElm.Modules.Sdf as Sdf
import PlayElm.Types as Types


chars : String
chars =
    "...::/\\/\\/\\+=*abcdef01XYZ#"


tableSize : Int
tableSize =
    256


run : Types.Runnable
run context =
    let
        t =
            context.time * 0.0015

        currentBuffer =
            if context.resized then
                Array.initialize (context.cols * context.rows) (always 0)

            else
                context.buffer

        ( rRands, rest1 ) =
            ListExtra.splitAt tableSize context.effects.generatedFloats

        ( pRands, rest2 ) =
            ListExtra.splitAt tableSize rest1

        ( cursorRand, dataRands ) =
            ListExtra.splitAt 1 rest2

        noiseF =
            valueNoise (Array.fromList rRands) (Array.fromList pRands)

        calcNoise rowNum colNum =
            if rowNum == 0 then
                Num.map (noiseF (toFloat colNum * 0.05) t) 0 1 5 40 |> floor

            else
                0

        row rowNum =
            List.foldr (\colNum str -> str ++ runLine (calcNoise rowNum colNum)) "" (List.range 0 (context.cols - 1))

        newScreen =
            List.foldr (\rowNum -> Array.push (row rowNum)) Array.empty (List.range 0 (context.rows - 1))
    in
    { context | screen = newScreen }


runLine : Int -> String
runLine u =
    if u == 0 then
        " "

    else
        let
            charsIndex =
                clamp 0 (String.length chars) u
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
                            Array.get k permutationRnd |> Maybe.map (\x -> x * toFloat tableSize) |> Maybe.withDefault 0 |> floor

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
