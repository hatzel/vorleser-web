module View.BookList exposing (..)

import Model exposing (Model, Mdl)
import Material.List as Lists
import Msg
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Options as Options
import Material.Grid as Grid
import Material.Options as Options
import Material.Icon as Icon
import Material
import Material.Snackbar as Snackbar
import View.Playback

type alias Mdl =
  Material.Model

view: Model -> Html Msg.Msg
view model =
  Grid.grid [] [
    Grid.cell []
    [ (Lists.ul []
      (
      List.map2
      (\book -> \k -> (listItem model book k))
      model.books
      (List.range 0 (List.length model.books))
      ))
      , View.Playback.view model
      , Snackbar.view model.snackbar |> Html.map Msg.Snackbar
    ]
    -- View.Playback.view model
  ]


listItem: Model -> Model.Audiobook -> Int -> Html Msg.Msg
listItem model book index =
  let subtitle =
    case book.artist of
      Just author ->
        author ++ " — (" ++ formatTime book.length ++ ")"
      _ ->
        "(" ++ formatTime book.length ++ ")"
  in
    -- let playButton =
    --   (\id -> \index -> Button.render Msg.Mdl [index] model.mdl [Button.icon] [ Icon.i "play_circle_outline" ])
    --   -- , Button.accent |> when (Set.member k model.toggles)
    --   -- ]
    Lists.li [ Lists.withSubtitle ] [ Lists.content []
    [ text book.title
    , playButton model index book.id
    , Lists.subtitle [] [ text subtitle ]
    ] ]

playButton: Model -> Int -> String -> Html Msg.Msg
playButton model index id =
  Button.render
  Msg.Mdl
  [index]
  model.mdl
  [ Button.icon
  , Options.onClick (Msg.PlayBook id)
  ]
  [ Icon.i "play_circle_outline" ]

formatTime: Float -> String
formatTime seconds =
  let (hours, minutes) =
    ((round seconds) // 3600, ((round seconds) % 3600) // 60)
  in
    (String.padLeft 2 '0' (toString hours)) ++ ":" ++ (String.padLeft 2 '0' (toString minutes))
