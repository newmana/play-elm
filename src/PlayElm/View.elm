module PlayElm.View exposing (view)

import Html as Html
import Html.Attributes as HtmlAttributes
import Html.Events.Extra.Mouse as MouseEvent
import PlayElm.Model as Model
import PlayElm.Msg as Msg


view : Model.Model -> List (Html.Html Msg.Msg)
view model =
    [ Html.pre
        [ HtmlAttributes.id Model.elementId, MouseEvent.onMove Msg.MouseMove ]
        []
    ]
