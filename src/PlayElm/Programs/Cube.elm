module PlayElm.Programs.Cube exposing (run)

import Array
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


edges : List ( Int, Int )
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
            2.0

        zOffs =
            Num.map (sin (t * 0.12)) -1.0 1.0 -2.5 -6.0

        boxProj =
            List.map
                (\( vX, vY, vZ ) ->
                    let
                        rotateX =
                            Vec3.rotX ( vX, vY, vZ ) rotX

                        rotateY =
                            Vec3.rotY rotateX rotY

                        ( rotateZX, rotateZY, rotateZZ ) =
                            Vec3.rotZ rotateY rotZ
                    in
                    Vec2.mulN ( rotateZX, rotateZY ) (d / (rotateZZ - zOffs))
                )
                vertices
                |> Array.fromList

        row rowNum =
            List.foldl (\colNum str -> str ++ runLine context boxProj colNum rowNum) "" (List.range 0 (context.cols - 1))

        newScreen =
            List.foldl (\rowNum -> Array.push (row rowNum)) Array.empty (List.range 0 (context.rows - 1))
    in
    { context | screen = newScreen }


runLine : Types.CommonContext {} -> Array.Array ( Float, Float ) -> Int -> Int -> String
runLine context boxProj x y =
    let
        m =
            min context.cols context.rows |> toFloat

        a =
            context.aspect

        stX =
            2.0 * ((toFloat x - toFloat context.cols / 2.0) + 0.5) / m * a

        stY =
            2.0 * ((toFloat y - toFloat context.rows / 2.0) + 0.5) / m

        thickness =
            Num.map (Types.cursor context |> .x) 0.0 (context.cols |> toFloat) 0.001 0.1

        d =
            List.foldl
                (\edge currD ->
                    let
                        aa =
                            Array.get (Tuple.first edge) boxProj |> Maybe.withDefault ( 0, 0 )

                        bb =
                            Array.get (Tuple.second edge) boxProj |> Maybe.withDefault ( 0, 0 )
                    in
                    min currD (Sdf.sdSegment ( stX, stY ) aa bb thickness)
                )
                1.0e10
                edges
    in
    if d == 0 then
        " "

    else
        let
            expMul =
                Num.map (Types.cursor context |> .y) 0.0 (context.rows |> toFloat) -100 -5

            charsIndex =
                floor ((e ^ (expMul * abs d)) * (String.length chars |> toFloat))
        in
        String.slice charsIndex (charsIndex + 1) chars
