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
            List.concatMap
                (\programName ->
                    [ Html.input
                        [ HtmlAttributes.type_ "radio"
                        , HtmlEvents.onClick <| Msg.RunProgram programName
                        , HtmlAttributes.checked (programName == rm.programName)
                        ]
                        []
                    , Html.label [] [ Html.text programName ]
                    , Html.br [] []
                    ]
                )
                (Dict.keys rm.programs)

        buttons =
            case model of
                Model.Booting _ ->
                    []

                Model.Running rm ->
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
    case model of
        Model.Booting _ ->
            []

        Model.Running rm ->
            Array.map
                (\l ->
                    Html.span [ HtmlAttributes.style "display" "block" ]
                        [ Html.text l ]
                )
                rm.context.screen
                |> Array.toList

        Model.Executing rm ->
            Array.map
                (\l ->
                    Html.span [ HtmlAttributes.style "display" "block" ]
                        [ Html.text l ]
                )
                rm.context.screen
                |> Array.toList
