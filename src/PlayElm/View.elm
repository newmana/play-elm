module PlayElm.View exposing (view)

import Array as Array
import Html as Html
import Html.Attributes as HtmlAttributes
import Html.Events.Extra.Mouse as MouseEvent
import PlayElm.Model as Model
import PlayElm.Msg as Msg


view : Model.Model -> List (Html.Html Msg.Msg)
view model =
    [ Html.pre
        [ HtmlAttributes.id Model.elementId, MouseEvent.onMove Msg.MouseMove ]
        (viewScreen model)
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
