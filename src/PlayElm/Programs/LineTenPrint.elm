module PlayElm.Programs.LineTenPrint exposing (generateMaze)

import Random
import Random.String as RandomString


generateMaze : Int -> Random.Generator String
generateMaze number =
    RandomString.string number generateSlash


generateSlash : Random.Generator Char
generateSlash =
    let
        flip =
            Random.int 0 1

        slash pick =
            case pick of
                0 ->
                    '/'

                _ ->
                    '\\'
    in
    Random.map slash flip
