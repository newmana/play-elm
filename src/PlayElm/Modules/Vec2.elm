module PlayElm.Modules.Vec2 exposing (dot, length, mulN, sub)


sub : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
sub ( aX, aY ) ( bX, bY ) =
    ( aX - bX, aY - bY )


mulN : ( Float, Float ) -> Float -> ( Float, Float )
mulN ( aX, aY ) k =
    ( aX * k, aY * k )


dot : ( Float, Float ) -> ( Float, Float ) -> Float
dot ( aX, aY ) ( bX, bY ) =
    aX * bX + aY * bY


length : ( Float, Float ) -> Float
length ( x, y ) =
    sqrt ((x * x) + (y * y))
