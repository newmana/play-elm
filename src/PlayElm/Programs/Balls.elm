module PlayElm.Programs.Balls exposing (run)

import PlayElm.Types as Types
import Time as Time


chars : String
chars =
    "╳ABC|/:÷×+-=?*· ."


tau : Float
tau =
    pi * 2


map : Float -> Float -> Float -> Float -> Float -> Float
map v inA inB outA outB =
    outA + (outB - outA) * ((v - inA) / (inB - inA))


mix : Float -> Float -> Float -> Float
mix v1 v2 a =
    v1 * (1 - a) + v2 * a


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
            dx * s - dy * c
    in
    ( newX, newY )


length2D : ( Float, Float ) -> Float
length2D ( x, y ) =
    sqrt ((x * x) + (y * y))


opSmoothUnion : Float -> Float -> Float -> Float
opSmoothUnion d1 d2 k =
    let
        h =
            clamp (0.5 + 0.5 * (d2 - d1) / k) 0.0 1.0
    in
    mix d2 d1 h - k * h * (1.0 - h)


sdCircle : ( Float, Float ) -> Float -> Float
sdCircle p radius =
    length2D p - radius


run : Int -> Int -> Types.Context -> Char
run x y context =
    let
        a =
            min context.cols context.rows |> toFloat

        stX =
            2 * ((x - context.cols |> toFloat) / 2) / a * context.aspect

        stY =
            2 * ((y - context.rows |> toFloat) / 2) / a

        s =
            map (sin ((Time.posixToMillis context.time |> toFloat) * 0.0005)) -1 1 0.0 0.9
    in
    'A'
