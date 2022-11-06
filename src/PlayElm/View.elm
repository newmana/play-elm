module PlayElm.View exposing (view)

import Array
import Dict
import Html
import Html.Attributes as HtmlAttributes
import Html.Events as HtmlEvents
import Html.Events.Extra.Mouse as MouseEvent
import PlayElm.Model as Model
import PlayElm.Msg as Msg
import PlayElm.Types as Types


view : Model.Model -> List (Html.Html Msg.Msg)
view model =
    [ Html.div [ HtmlAttributes.class "flex-container" ]
        [ Html.div
            [ HtmlAttributes.class "flex-left" ]
            [ Html.pre
                [ HtmlAttributes.id Types.elementId
                , MouseEvent.onMove Msg.MouseMove
                , MouseEvent.onDown (\_ -> Msg.MouseDown)
                , MouseEvent.onUp (\_ -> Msg.MouseUp)
                ]
                (viewScreen model)
            ]
        , Html.div
            [ HtmlAttributes.class "flex-right" ]
            (viewPrograms model)
        ]
    ]


viewPrograms : Model.Model -> List (Html.Html Msg.Msg)
viewPrograms model =
    let
        radioButtons rm =
            let
                firstProgramName =
                    Dict.keys rm.programs |> List.head |> Maybe.withDefault ""
            in
            List.map
                (\programName ->
                    Html.label []
                        [ Html.input
                            [ HtmlAttributes.type_ "radio"
                            , HtmlAttributes.name "program"
                            , HtmlAttributes.autofocus (programName == firstProgramName)
                            , HtmlEvents.onClick <| Msg.RunProgram programName
                            , HtmlAttributes.checked (programName == rm.programName)
                            ]
                            []
                        , Html.span [] [ Html.text programName ]
                        , Html.br [] []
                        ]
                )
                (Dict.keys rm.programs)

        buttons =
            case model of
                Model.Booting _ ->
                    []

                Model.Fetch rm ->
                    radioButtons rm

                Model.Executing em ->
                    radioButtons em

        html =
            [ Html.div []
                [ Html.fieldset []
                    buttons
                ]
            ]
    in
    html


viewScreen : Model.Model -> List (Html.Html Msg.Msg)
viewScreen model =
    let
        screenRender screen =
            Array.map
                (\l ->
                    Html.span [ HtmlAttributes.style "display" "block" ]
                        [ Html.text l ]
                )
                screen
                |> Array.toList
    in
    case model of
        Model.Booting _ ->
            []

        Model.Fetch rm ->
            screenRender rm.context.screen

        Model.Executing rm ->
            screenRender rm.context.screen
