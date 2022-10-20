module PlayElm.Modules.Vec2 exposing (add, div, dot, length, mul, sub)


add : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
add ( aX, aY ) ( bX, bY ) =
    ( aX + bX, aY + bY )


sub : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
sub ( aX, aY ) ( bX, bY ) =
    ( aX - bX, aY - bY )


mul : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
mul ( aX, aY ) ( bX, bY ) =
    ( aX * bX, aY * bY )


div : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
div ( aX, aY ) ( bX, bY ) =
    ( aX / bX, aY / bY )


dot : ( Float, Float ) -> ( Float, Float ) -> Float
dot ( aX, aY ) ( bX, bY ) =
    aX * bX + aY * bY


length : ( Float, Float ) -> Float
length ( x, y ) =
    sqrt ((x * x) + (y * y))
