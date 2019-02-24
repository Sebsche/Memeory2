module Main exposing (main)

import Array exposing (Array, get, repeat, set)
import Browser
import Html exposing (Html, button, div, p, table, td, text, tr, img)
import Html.Attributes exposing (style, src)
import Html.Events exposing (onClick)
import String exposing (fromChar)
import Random
import Random.List

type alias Card =
    { id: Int
    , pic: Int
    , flipped: Bool
    }

type alias BoardRow = Array.Array Card
type alias GameBoard = Array.Array BoardRow

--createList : List

createBoard : Int -> Int -> (Int -> Card) -> GameBoard
createBoard x y function =
    Array.initialize x (\m -> (Array.initialize y (\n -> function (m*x+n))))

displayFunc : Card -> Html Msg
displayFunc le_cell =
      if le_cell.flipped == True then
        img [src ("card/" ++ String.fromInt le_cell.pic ++ ".png")] []
      else
        img [src "card/back.png", onClick <| Flip le_cell] []
    --Kombination aus:
    --Html.td [] [Html.text (String.fromInt le_cell.pic)]
    --img [src "card/4.png"] []

displayRow : (Card -> Html Msg) -> BoardRow -> Html Msg
displayRow function le_row =
    Html.tr [] (Array.toList <| Array.map function le_row)

displayBoard : (Card -> Html Msg) -> GameBoard -> Html Msg
displayBoard function le_board =
    Html.table [] (Array.toList <| Array.map (displayRow function) le_board)

type alias Model =
    { board: Array Char
    , player : Int
    , test_board: GameBoard}

initialModel : () -> (Model, Cmd Msg)
initialModel _ =
    ({ board = repeat 16 '_'
    , player = 1
    , test_board = createBoard 4 4 (\n -> {id=n, pic=0, flipped=False})}
    , Random.generate SetCards (Random.List.shuffle (List.append (List.range 0 7) (List.range 0 7)))
    )

type Msg
    = Play Int
    | SetCards (List Int)
    | Flip Card

setModel : List Int -> flags -> (Model, Cmd Msg)
setModel list _ =
    ({ board = repeat 16 '_'
    , player = 1
    , test_board = createBoard 4 4 (\n -> {id=n, flipped=False, pic= Array.get n (Array.fromList list) |> Maybe.withDefault 0})}
    , Cmd.none
    )

setFlipped : Model -> Card -> (Model, Cmd Msg)
setFlipped model card =
      (model, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Play n ->
            ({ model | board = set n 'X' model.board}, Cmd.none)

        Flip card ->
            ({ model | test_board = set 1 True test_board.card}, Cmd.none)
            --setFlipped model card

        SetCards list ->
            setModel list 0

view : Model -> Html Msg
view model =
    div []
        [ p []
            [text "Memeory"
            ]
        , displayBoard displayFunc model.test_board
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

main : Program () Model Msg
main =
    Browser.element
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
