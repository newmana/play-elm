module PlayElm.Programs.Cube exposing (..)

import Array as Array
import PlayElm.Modules.Num as Num
import PlayElm.Modules.Sdf as Sdf
import PlayElm.Modules.Vec2 as Vec2
import PlayElm.Modules.Vec3 as Vec3
import PlayElm.Types as Types


chars : String
chars =
    " -=+abcdX"


l : Float
l =
    0.6


vertices : List ( Float, Float, Float )
vertices =
    [ ( l, l, l )
    , ( -l, l, l )
    , ( -l, -l, l )
    , ( l, -l, l )
    , ( l, l, -l )
    , ( -l, l, -l )
    , ( -l, -l, -l )
    , ( l, -l, -l )
    ]


edges : List ( Float, Float )
edges =
    [ ( 0, 1 )
    , ( 1, 2 )
    , ( 2, 3 )
    , ( 3, 0 )
    , ( 4, 5 )
    , ( 5, 6 )
    , ( 6, 7 )
    , ( 7, 4 )
    , ( 0, 4 )
    , ( 1, 5 )
    , ( 2, 6 )
    , ( 3, 7 )
    ]


run : Types.Runnable
run context =
    let
        t =
            context.time * 0.01

        ( rotX, rotY, rotZ ) =
            ( t * 0.11, t * 0.13, -t * 0.15 )

        d =
            2

        zOffs =
            Num.map (sin t * 0.12) -1.0 1.0 -2.5 -6.0

        boxProj =
            List.map
                (\( vX, vY, vZ ) ->
                    let
                        rotateX =
                            Vec3.rotX ( vX, vY, vZ ) rotX

                        rotateY =
                            Vec3.rotY rotateX rotY

                        rotateZ =
                            Vec3.rotZ rotateY rotZ
                    in
                    rotateZ
                )
                vertices

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
            context.time * 0.01

        m =
            min context.cols context.rows |> toFloat

        a =
            context.aspect

        stX =
            2.0 * (toFloat x - toFloat context.cols / 2.0) / m * a

        stY =
            2.0 * (toFloat y - toFloat context.rows / 2.0) / m

        d =
            1 ^ 10

        n =
            List.length edges

        thickness =
            Num.map (Types.cursor context |> .x |> toFloat) 0.0 (context.cols |> toFloat) 0.001 0.1

        radius =
            cos t * 0.4 + 0.5

        c =
            1.0 - (e ^ (-5 * abs d))

        charsIndex =
            floor (c * (String.length chars |> toFloat))
    in
    if x /= 0 && modBy 2 x == 0 then
        String.slice charsIndex (charsIndex + 1) chars

    else
        "|"
