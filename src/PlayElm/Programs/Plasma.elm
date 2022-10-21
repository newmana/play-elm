module PlayElm.Programs.Plasma exposing (run)

import Array
import PlayElm.Modules.Num as Num
import PlayElm.Modules.Vec2 as Vec2
import PlayElm.Types as Types


chars : String
chars =
    "$?01▄abc+-><:. "


run : Types.Runnable
run context =
    let
        row rowNum =
            List.foldl (\colNum str -> str ++ runLine context colNum rowNum) "" (List.range 0 (context.cols - 1))

        newScreen =
            List.foldl (\rowNum -> Array.push (row rowNum)) Array.empty (List.range 0 (context.rows - 1))
    in
    { context | screen = newScreen }


runLine : Types.CommonContext {} -> Int -> Int -> String
runLine context x y =
    let
        t1 =
            context.time * 0.009

        m =
            min context.cols context.rows |> toFloat

        a =
            context.aspect

        stX =
            2.0 * (toFloat x - toFloat context.cols / 2.0) / m * a

        stY =
            2.0 * (toFloat y - toFloat context.rows / 2.0) / m

        center =
            ( sin -t1, cos -t1 )

        v1 =
            sin (Vec2.dot ( toFloat x, toFloat y ) ( sin t1, cos t1 ) * 0.08)

        v2 =
            cos (Vec2.length (Vec2.sub ( stX, stY ) center) * 4.0)

        v3 =
            v1 + v2

        charsIndex =
            floor (Num.map v3 -2.0 2.0 0.0 1.0 * (String.length chars |> toFloat))
    in
    String.slice charsIndex (charsIndex + 1) chars
