module Main exposing (main)

import Array exposing (Array, get, repeat, set)
import Browser
import Html exposing (Html, button, div, p, table, td, text, tr, img)
import Html.Attributes exposing (style, src)
import Html.Events exposing (onClick)
import String exposing (fromChar)
import Random

type alias Card =
    { id: Int
    , pic: Int}

type alias BoardRow = Array.Array Card
type alias GameBoard = Array.Array BoardRow

createBoard : Int -> Int -> (Int -> Card) -> GameBoard
createBoard x y function =
    Array.initialize x (\m -> (Array.initialize y (\n -> function (m*x+n))))

displayFunc : Card -> Html Msg
displayFunc le_cell =
    Html.td [] [Html.text (String.fromInt le_cell.id)]

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


initialModel :  () -> (Model, Cmd Msg)
initialModel _ =
    ({ board = repeat 16 '_'
    , player = 1
    , test_board = createBoard 0 0 (\n -> {id=n, pic=0})}
    , Cmd.none
    )

type Msg
    = Play Int

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Play n ->
            ({ model | board = set n 'X' model.board}, Cmd.none)



view : Model -> Html Msg
view model =
    let
        border = style "border" "1px solid black"
        characterInCell n = get n model.board |> Maybe.withDefault ' '
        cell n = if characterInCell n == 'X'
            then
                img [src "http://icons.iconarchive.com/icons/jeanette-foshee/simpsons-10/32/Townspeople-Dr-Foster-Neds-child-shrink-icon.png"] []
            else
                img [src "https://github.com/GBBasel/memeory/blob/master/pics/Background.png"] []
    in
        div []
            [ text "Memeory"
            , p [] []
            , table []
                [ tr []
                    [ td [border, onClick <| Play 0] [cell 0]
                    , td [border, onClick <| Play 1] [cell 1]
                    , td [border, onClick <| Play 2] [cell 2]
                    , td [border, onClick <| Play 3] [cell 3]
                    ]
                , tr []
                    [ td [border, onClick <| Play 4] [cell 4]
                    , td [border, onClick <| Play 5] [cell 5]
                    , td [border, onClick <| Play 6] [cell 6]
                    , td [border, onClick <| Play 7] [cell 7]
                    ]
                , tr []
                    [ td [border, onClick <| Play 8] [cell 8]
                    , td [border, onClick <| Play 9] [cell 9]
                    , td [border, onClick <| Play 10] [cell 10]
                    , td [border, onClick <| Play 11] [cell 11]
                    ]
                , tr []
                    [ td [border, onClick <| Play 12] [cell 12]
                    , td [border, onClick <| Play 13] [cell 13]
                    , td [border, onClick <| Play 14] [cell 14]
                    , td [border, onClick <| Play 15] [cell 15]
                    ]
                 ]
            , p [] []
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
