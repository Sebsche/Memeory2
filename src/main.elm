module Main exposing (main)

import Array exposing (Array, get, repeat, set)
import Browser
import Html exposing (Html, br, button, div, h1, img, p, strong, table, td, text, tr)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import Random
import Random.List


type CardStatus
    = Hidden
    | Visible
    | Found


type alias Card =
    { id : Int
    , pic : Int
    , status : CardStatus
    }


type alias BoardRow =
    Array.Array Card


type alias GameBoard =
    Array.Array BoardRow


type alias Model =
    { board : GameBoard
    , selectedFirstPic : Int
    , selectedCount : Int
    , player : Int
    , player1Score : Int
    , player2Score : Int
    }


type Msg
    = SetCards (List Int)
    | Flip Card



-- *****************************************
-- Initialize Model
-- *****************************************


initialModel : () -> ( Model, Cmd Msg )
initialModel _ =
    ( { player = 1
      , player1Score = 0
      , player2Score = 0
      , selectedFirstPic = -1
      , selectedCount = 0
      , board = createBoard 4 4 (\n -> { id = n, pic = 0, status = Hidden })
      }
    , Random.generate SetCards (Random.List.shuffle (List.append (List.range 0 7) (List.range 0 7)))
    )


createBoard : Int -> Int -> (Int -> Card) -> GameBoard
createBoard x y function =
    Array.initialize x (\m -> Array.initialize y (\n -> function (m * x + n)))



-- *****************************************
-- Update
-- *****************************************


setCard : Card -> (Card -> Card) -> GameBoard -> GameBoard
setCard card func board =
    Array.map
        (\row ->
            Array.map
                (\cell ->
                    if cell.id == card.id then
                        func cell

                    else
                        cell
                )
                row
        )
        board


setCardFound : Int -> GameBoard -> GameBoard
setCardFound pic board =
    Array.map
        (\row ->
            Array.map
                (\cell ->
                    if cell.pic == pic then
                        { cell | status = Found }

                    else
                        cell
                )
                row
        )
        board


hideCardsGuessed : Card -> GameBoard -> GameBoard
hideCardsGuessed card board =
    Array.map
        (\row ->
            Array.map
                (\cell ->
                    if cell.status == Visible then
                        { cell | status = Hidden }

                    else if cell.id == card.id then
                        { cell | status = Visible }

                    else
                        cell
                )
                row
        )
        board


setSelectedCard : Card -> Model -> Model
setSelectedCard card model =
    { model
        | selectedFirstPic =
            if model.selectedCount == 0 then
                card.pic

            else
                model.selectedFirstPic
        , selectedCount = model.selectedCount + 1
    }


resetSelectedCard : Model -> Model
resetSelectedCard model =
    { model
        | selectedFirstPic = -1
        , selectedCount = 0
    }


switchPlayer : Model -> Model
switchPlayer model =
    { model
        | player =
            if model.player == 1 then
                2

            else
                1
    }


scorePlayer : Model -> Model
scorePlayer model =
    { model
        | player1Score =
            if model.player == 1 then
                model.player1Score + 1

            else
                model.player1Score
        , player2Score =
            if model.player == 2 then
                model.player2Score + 1

            else
                model.player2Score
    }


makeModel : Model -> GameBoard -> Model
makeModel model board =
    { model | board = board }


setModel : List Int -> flags -> ( Model, Cmd Msg )
setModel list _ =
    ( { player = 1
      , player1Score = 0
      , player2Score = 0
      , selectedFirstPic = -1
      , selectedCount = 0
      , board = createBoard 4 4 (\n -> { id = n, status = Hidden, pic = Array.get n (Array.fromList list) |> Maybe.withDefault 0 })
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Flip card ->
            case card.status of
                Hidden ->
                    -- second card is played and cards are equal -> show card, mark cards as 'found'
                    if model.selectedCount == 1 && card.pic == model.selectedFirstPic then
                        ( resetSelectedCard <|
                            scorePlayer <|
                                makeModel model <|
                                    setCardFound model.selectedFirstPic model.board
                        , Cmd.none
                        )


                    else if model.selectedCount == 1 then
                        -- second card is played, but not equal -> show card
                        ( switchPlayer <|
                            setSelectedCard card <|
                                makeModel model <|
                                    setCard card (\cell -> { cell | status = Visible }) model.board
                        , Cmd.none
                        )

                    else if model.selectedCount > 1 then
                        -- third card is played -> show card, hide all guessed cards
                        ( setSelectedCard card <|
                            resetSelectedCard <|
                                makeModel model <|
                                    hideCardsGuessed card model.board
                        , Cmd.none
                        )

                    else
                        -- first card is played -> show card
                        ( setSelectedCard card <|
                            makeModel model <|
                                setCard card (\cell -> { cell | status = Visible }) model.board
                        , Cmd.none
                        )

                Visible ->
                    -- you may not hide a card (auto hide is engaged) -> do nothing
                    ( model, Cmd.none )

                Found ->
                    -- found is found -> do nothing
                    ( model, Cmd.none )

        SetCards list ->
            setModel list 0



-- *****************************************
-- View
-- *****************************************


displayFunc : Card -> Html Msg
displayFunc le_cell =
    if le_cell.status == Visible || le_cell.status == Found then
        img [ src ("card/" ++ String.fromInt le_cell.pic ++ ".png"), onClick <| Flip le_cell ] []

    else
        img [ src "card/back.png", onClick <| Flip le_cell ] []


displayRow : (Card -> Html Msg) -> BoardRow -> Html Msg
displayRow function le_row =
    Html.tr []
        (Array.toList <|
            Array.map function le_row
        )


displayBoard : (Card -> Html Msg) -> GameBoard -> Html Msg
displayBoard function le_board =
    Html.table []
        (Array.toList <|
            Array.map (displayRow function) le_board
        )


playerMsg : Model -> Html Msg
playerMsg model =
    if model.player1Score + model.player2Score == 8 then
        div []
            [ text
                (if model.player1Score == model.player2Score then
                    "Draw!"

                 else if model.player1Score > model.player2Score then
                    "Player 1 wins!"

                 else
                    "Player 2 wins!"
                )
            , text " - GAME OVER."
            ]

    else if model.player == 1 then
        div [] [ text "Player 1 to play." ]

    else
        div [] [ text "Player 2 to play." ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Memeory" ]
        , p [] []
        , displayBoard displayFunc model.board
        , p [] []
        , strong [] [ playerMsg model ]
        , p [] []
        , text "Player 1 score: "
        , strong [] [ text (String.fromInt model.player1Score) ]
        , br [] []
        , text "Player 2 score: "
        , strong [] [ text (String.fromInt model.player2Score) ]
        ]



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
