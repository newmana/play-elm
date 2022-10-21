module PlayElm.Modules.Vec3 exposing (rotX, rotY, rotZ)


rotX : ( Float, Float, Float ) -> Float -> ( Float, Float, Float )
rotX ( x, y, z ) ang =
    let
        c =
            cos ang

        s =
            sin ang

        newY =
            (y * c) - (z * s)

        newZ =
            (y * s) + (z * c)
    in
    ( x, newY, newZ )


rotY : ( Float, Float, Float ) -> Float -> ( Float, Float, Float )
rotY ( x, y, z ) ang =
    let
        c =
            cos ang

        s =
            sin ang

        newX =
            (x * c) + (z * s)

        newZ =
            (-x * s) + (z * c)
    in
    ( newX, y, newZ )


rotZ : ( Float, Float, Float ) -> Float -> ( Float, Float, Float )
rotZ ( x, y, z ) ang =
    let
        c =
            cos ang

        s =
            sin ang

        newX =
            (x * c) - (y * s)

        newY =
            (x * s) + (y * c)
    in
    ( newX, newY, z )
