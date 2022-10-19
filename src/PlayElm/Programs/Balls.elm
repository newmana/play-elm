module PlayElm.Programs.Balls exposing (run, transform)

import Array as Array
import PlayElm.Modules.Num as Num
import PlayElm.Modules.Sdf as Sdf
import PlayElm.Types as Types
import Time as Time


chars : String
chars =
    "#ABC|/:÷×+-=?*· "


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
            transform ( stX, stY ) ( dX num i, dY num i ) t

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


transform : ( Float, Float ) -> ( Float, Float ) -> Float -> ( Float, Float )
transform ( pX, pY ) ( transX, transY ) rot =
    let
        s =
            sin -rot

        c =
            cos -rot

        dx =
            pX - transX

        dy =
            pY - transY

        newX =
            dx * c - dy * s

        newY =
            dx * s + dy * c
    in
    ( newX, newY )
