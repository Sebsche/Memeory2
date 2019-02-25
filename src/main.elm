module Main exposing (main)

import Array exposing (Array, get, repeat, set)
import Browser
import Html exposing (Html, button, div, p, table, td, text, tr, img)
import Html.Attributes exposing (style, src)
import Html.Events exposing (onClick)
import String exposing (fromChar)
import Random
import Random.List

type CardStatus
    = Hidden
    | Visible
    | Found

type alias Card =
    { id: Int
    , pic: Int
    , status: CardStatus}

type alias BoardRow = Array.Array Card
type alias GameBoard = Array.Array BoardRow

type alias Model =
    { board: GameBoard
     , selectedFirstPic: Int
     , selectedCount: Int
     , count: Int
    }

type Msg
    = SetCards (List Int)
    | Flip Card
    | Increment
    | Decrement


-- *****************************************
-- Initailize Model
-- *****************************************

initialModel : () -> (Model, Cmd Msg)
initialModel _ =
    ({ selectedFirstPic = -1
    , selectedCount = 0
    , count = 0
    , board = createBoard 4 4 (\n -> {id=n, pic=0, status=Hidden})}
    , Random.generate SetCards (Random.List.shuffle (List.append (List.range 0 7) (List.range 0 7)))
    )


createBoard : Int -> Int -> (Int -> Card) -> GameBoard
createBoard x y function =
    Array.initialize x (\m -> (Array.initialize y (\n -> function (m*x+n))))

-- *****************************************
-- View
-- *****************************************

displayFunc : Card -> Html Msg
displayFunc le_cell =
    if le_cell.status == Visible || le_cell.status == Found then
        img [src ("card/" ++ String.fromInt le_cell.pic ++ ".png"), onClick <| Flip le_cell] []
    else
        img [src ("card/back.png"), onClick <| Flip le_cell] []


displayRow : (Card -> Html Msg) -> BoardRow -> Html Msg
displayRow function le_row =
    Html.tr [] (Array.toList <| Array.map function le_row)

displayBoard : (Card -> Html Msg) -> GameBoard -> Html Msg
displayBoard function le_board =
    Html.table [] (Array.toList <| Array.map (displayRow function) le_board)

view : Model -> Html Msg
view model =
    div []
        [ text "Memeory"
        , p [] []
        , displayBoard displayFunc model.board
        , button [ onClick Increment ] [ text "Player 1 has a pair" ]
        , div [] [ text <| String.fromInt model.count ]
        , button [ onClick Decrement ] [ text "Player 2 has a pair" ]
        ]


-- *****************************************
-- Update
-- *****************************************

setCard : Card -> (Card -> Card) -> GameBoard -> GameBoard
setCard card func board =
    Array.map (\row -> Array.map (\cell -> if cell.id == card.id then func cell else cell) row) board

setCardFound : Int -> (Card -> Card) -> GameBoard -> GameBoard
setCardFound pic func board =
    Array.map (\row -> Array.map (\cell -> if cell.pic == pic then func cell else cell) row) board

setSelectedCard : Card -> Model -> Model
setSelectedCard card model = { model | selectedFirstPic = (if model.selectedCount == 0 then card.pic else model.selectedFirstPic)
            , selectedCount = model.selectedCount + 1 }

resetSelectedCard : Card -> Model -> Model
resetSelectedCard card model = { model | selectedFirstPic = (if model.selectedCount == 1 then -1 else model.selectedFirstPic)
            , selectedCount = model.selectedCount - 1 }

makeModel : Model -> GameBoard -> Model
makeModel model board =
    {model | board = board}

setModel : List Int -> flags -> (Model, Cmd Msg)
setModel list _ =
    ({selectedFirstPic = -1
    , selectedCount = 0
    , count = 0
    , board = createBoard 4 4 (\n -> {id=n, status=Hidden, pic=Array.get n (Array.fromList list) |> Maybe.withDefault 0})}
    , Cmd.none
    )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Flip card ->

            case card.status of
                Hidden ->
                   if model.selectedCount == 1 && card.pic == model.selectedFirstPic then
                       ( resetSelectedCard card <| makeModel model <| setCardFound model.selectedFirstPic (\cell -> {cell | status=Found}) model.board, Cmd.none)
                   else if model.selectedCount == 1 then
                       ( setSelectedCard card <| makeModel model <| setCard card (\cell -> {cell | status=Visible}) model.board, Cmd.none)
                   else if model.selectedCount > 1 then
                       ( model, Cmd.none )
                   else
                       ( setSelectedCard card <| makeModel model <| setCard card (\cell -> {cell | status=Visible}) model.board, Cmd.none)
                Visible ->
                   ( resetSelectedCard card <| makeModel model <| setCard card (\cell -> {cell | status=Hidden}) model.board, Cmd.none)
                Found ->
                   ( model, Cmd.none )

        SetCards list ->
            setModel list 0

        Increment ->
            ({ model | count = model.count + 1 }, Cmd.none)

        Decrement ->
            ({ model | count = model.count - 1 }, Cmd.none)


-- *****************************************
-- Subscription (only needed for Random.List)
-- *****************************************
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- *****************************************
-- Main
-- *****************************************

main : Program () Model Msg
main =
    Browser.element
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
