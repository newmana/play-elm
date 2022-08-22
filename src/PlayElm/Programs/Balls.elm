module PlayElm.Programs.Balls exposing (run)

import PlayElm.Types as Types
import Time as Time


chars : String
chars =
    "#ABC|/:÷×+-=?*· "


tau : Float
tau =
    pi * 2


map : Float -> Float -> Float -> Float -> Float -> Float
map v inA inB outA outB =
    outA + (outB - outA) * ((v - inA) / (inB - inA))


mix : Float -> Float -> Float -> Float
mix v1 v2 a =
    v1 * (1 - a) + (v2 * a)


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
            (dx * c) - (dy * s)

        newY =
            (dx * s) - (dy * c)
    in
    ( newX, newY )


length2D : ( Float, Float ) -> Float
length2D ( x, y ) =
    sqrt ((x * x) + (y * y))


opSmoothUnion : Float -> Float -> Float -> Float
opSmoothUnion d1 d2 k =
    let
        h =
            clamp 0.0 1.0 (0.5 + 0.5 * (d2 - d1) / k)
    in
    mix d2 d1 h - (k * h * (1.0 - h))


sdCircle : ( Float, Float ) -> Float -> Float
sdCircle p radius =
    length2D p - radius


run : Types.Context -> Int -> Int -> String
run context x y =
    let
        t =
            (context.time * 0.001) + 10

        m =
            min context.cols context.rows |> toFloat

        a =
            context.aspect

        stX =
            2 * ((x - context.cols |> toFloat) / 2) / (m * a)

        stY =
            2 * ((y - context.rows |> toFloat) / 2) / m

        s =
            map (sin (t * 0.5)) -1 1 0.0 0.9

        dR num i =
            map (cos (t * 0.95 * (i + 1) / (num + 1))) -1 1 0.1 0.3

        dX num i =
            map (cos (t * 0.23 * ((i / num) * (pi + pi)))) -1 1 -1.2 1.2

        dY num i =
            map (sin (t * 0.37 * ((i / num) * (pi + pi)))) -1 1 -1.2 1.2

        dF num i =
            transform ( stX, stY ) ( dX num i, dY num i ) t

        maxNum =
            12

        calc fIndex currentD =
            opSmoothUnion currentD (sdCircle (dF maxNum fIndex) (dR maxNum fIndex)) s

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
