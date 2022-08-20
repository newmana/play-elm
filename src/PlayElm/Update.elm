module PlayElm.Update exposing (update)

import PlayElm.Model as Model
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Util as Util
import Time as Time


update : Msg.Msg -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.Tick newTime ->
            let
                _ =
                    Debug.log "Move " ((Tuple.first model.pointer |> String.fromFloat) ++ " " ++ (Time.posixToMillis model.time |> String.fromInt))
            in
            ( { model | time = newTime }, Cmd.none ) |> Util.addCmd (Port.getBoundingClientRect Model.elementId)

        Msg.MouseMove e ->
            let
                _ =
                    Debug.log "Move " ((Tuple.first e.pagePos |> String.fromFloat) ++ " " ++ (Time.posixToMillis model.time |> String.fromInt))
            in
            ( { model | pointer = e.pagePos }, Cmd.none )

        Msg.SetBoundingClientRect r ->
            case r of
                Just rect ->
                    let
                        _ =
                            Debug.log "HW" (String.fromFloat rect.height ++ ", " ++ String.fromFloat rect.width)
                    in
                    ( { model | widthHeight = ( rect.width, rect.height ) }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
