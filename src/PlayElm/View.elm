module PlayElm.View exposing (view)

import Array as Array
import Html as Html
import Html.Attributes as HtmlAttributes
import Html.Events.Extra.Mouse as MouseEvent
import PlayElm.Model as Model
import PlayElm.Msg as Msg


view : Model.Model -> List (Html.Html Msg.Msg)
view model =
    [ Html.div [ HtmlAttributes.class "flex-container" ]
        [ Html.div
            [ HtmlAttributes.class "flex-left" ]
            [ Html.pre
                [ HtmlAttributes.id Model.elementId, MouseEvent.onMove Msg.MouseMove ]
                (viewScreen model)
            ]
        , Html.div
            [ HtmlAttributes.class "flex-right" ]
            (viewPrograms model)
        ]
    ]


viewPrograms : Model.Model -> List (Html.Html Msg.Msg)
viewPrograms model =
    [ Html.div []
        [ Html.fieldset []
            [ Html.input [ HtmlAttributes.type_ "radio" ] [ Html.label [] [ Html.text "Hi" ] ]
            , Html.br [] [ Html.text "Hi" ]
            , Html.input [ HtmlAttributes.type_ "radio" ] [ Html.label [] [] ]
            , Html.br [] []
            , Html.input [ HtmlAttributes.type_ "radio" ] [ Html.label [] [] ]
            ]
        ]
    ]


viewScreen : Model.Model -> List (Html.Html Msg.Msg)
viewScreen model =
    case model of
        Model.Booting bm ->
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
