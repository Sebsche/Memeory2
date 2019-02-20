import Random
import Array exposing (Array, get, repeat, set)
import Browser
import Html exposing (Html, button, div, p, table, td, text, tr, img)
import Html.Attributes exposing (style, src)
import Html.Events exposing (onClick)
import String exposing (fromChar)

-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL

type alias GameCell =
    { id: Int
    , piece: Int}

type alias BoardRow = Array.Array GameCell
type alias GameBoard = Array.Array BoardRow

createBoard : Int -> Int -> (Int -> GameCell) -> GameBoard
createBoard x y function =
    Array.initialize x (\m -> (Array.initialize y (\n -> function (m*x+n))))

displayFunc : GameCell -> Html Msg
displayFunc le_cell =
    Html.td [] [Html.text (String.fromInt le_cell.id)]

displayRow : (GameCell -> Html Msg) -> BoardRow -> Html Msg
displayRow function le_row =
    Html.tr [] (Array.toList <| Array.map function le_row)

displayBoard : (GameCell -> Html Msg) -> GameBoard -> Html Msg
displayBoard function le_board =
Html.table [] (Array.toList <| Array.map (displayRow function) le_board)


type alias Card =
    { id : Int
    --, group : Group
    , flipped : Bool
    }

type alias Board = List (List Card)

type alias Model =
    { board: Array Char
    , player : Int
    , test_board: GameBoard}
    }

init : () -> (Model, Cmd Msg)
init _ =
  ( {dieFace = 1, board = [[{id = 1, flipped = False},{id = 2, flipped = False}],
                          [{id = 1, flipped = False},{id = 2, flipped = False}]]}
  , Cmd.none
  )

cardClass : Card -> String
cardClass card =
    "card-" ++ (String.fromInt card.id)


{-createCard card =
    div [ "container" ]
        -- try changing ("flipped", False) into ("flipped", True)
        [ div [ classList [ ( "card", True ), ( "flipped", False ) ] ]
            [ div [ "card-back" ] []
            , div [ ("front " ++ cardClass card) ] []
            ]
        ]-}



-- UPDATE


type Msg
  = Roll
  | NewFace Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      ( model
      , Cmd.none
      )

    NewFace newFace ->
      ( model
      , Cmd.none
      )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


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
        div [] List.map (\row -> Html.div [] List.map (\card -> Html.div [] []) row)
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
