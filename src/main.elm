module Main exposing (main)

import Array exposing (Array, get, repeat, set)
import Browser
import Html exposing (Html, button, div, img, p, table, td, text, tr)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import Random
import Random.List
import String exposing (fromChar)


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
    }


type Msg
    = SetCards (List Int)
    | Flip Card



-- *****************************************
-- Initialize Model
-- *****************************************


initialModel : () -> ( Model, Cmd Msg )
initialModel _ =
    ( { selectedFirstPic = -1
      , selectedCount = 0
      , board = createBoard 4 4 (\n -> { id = n, pic = 0, status = Hidden })
      }
    , Random.generate SetCards (Random.List.shuffle (List.append (List.range 0 7) (List.range 0 7)))
    )


createBoard : Int -> Int -> (Int -> Card) -> GameBoard
createBoard x y function =
    Array.initialize x (\m -> Array.initialize y (\n -> function (m * x + n)))



-- *****************************************
-- View
-- *****************************************


displayFunc : Card -> Html Msg
displayFunc le_cell =
    if le_cell.status == Visible || le_cell.status == Found then
        img [ src ("src/card/" ++ String.fromInt le_cell.pic ++ ".png"), onClick <| Flip le_cell ] []

    else
        img [ src "src/card/back.png", onClick <| Flip le_cell ] []


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


view : Model -> Html Msg
view model =
    div []
        [ text "Memeory"
        , p [] []
        , displayBoard displayFunc model.board
        ]



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



{-
   setCardFoundBad : Int -> (Card -> Card) -> GameBoard -> GameBoard
   setCardFoundBad pic func board =
       Array.map
           (\row ->
               Array.map
                   (\cell ->
                       if cell.pic == pic then
                           func cell

                       else
                           cell
                   )
                   row
           )
           board
-}


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

{-
resetSelectedCard : Model -> Model
resetSelectedCard model =
    { model
        | selectedFirstPic =
            if model.selectedCount == 1 then
                -1

            else
                model.selectedFirstPic
        , selectedCount = model.selectedCount - 1
    }
-}

resetSelectedCard : Model -> Model
resetSelectedCard model =
    { model
        | selectedFirstPic = -1
        , selectedCount = 0
    }


makeModel : Model -> GameBoard -> Model
makeModel model board =
    { model | board = board }


setModel : List Int -> flags -> ( Model, Cmd Msg )
setModel list _ =
    ( { selectedFirstPic = -1
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
                    -- zweite Karte aufgedeckt und diese ist gleich der ersten
                    if model.selectedCount == 1 && card.pic == model.selectedFirstPic then
                        ( resetSelectedCard <|
                            makeModel model <|
                                --setCardFound model.selectedFirstPic (\cell -> { cell | status = Found }) model.board
                                setCardFound model.selectedFirstPic model.board
                        , Cmd.none
                        )
                    -- zweite Karte aufgedecht und diese ist nicht gleich -> anzeigen
                    else if model.selectedCount == 1 then
                        ( setSelectedCard card <|
                            makeModel model <|
                                setCard card (\cell -> { cell | status = Visible }) model.board
                        , Cmd.none
                        )
                    -- dritte Karte aufgedeckt -> Karte anzeigen, alle anderen wieder umdrehen
                    else if model.selectedCount > 1 then
                        -- ( model, Cmd.none ) -- manuell umdrehen
                        ( setSelectedCard card <|
                            resetSelectedCard <|
                            makeModel model <|
                                hideCardsGuessed card model.board
                        , Cmd.none
                        )
                    -- erste Karte aufgedeckt -> anzeigen
                    else
                        ( setSelectedCard card <|
                            makeModel model <|
                                setCard card (\cell -> { cell | status = Visible }) model.board
                        , Cmd.none
                        )

                Visible ->
                {-
                    -- wieder zudecken
                    ( resetSelectedCard <|
                        makeModel model <|
                            setCard card (\cell -> { cell | status = Hidden }) model.board
                    , Cmd.none
                    )
                -}
                    -- nichts machen
                    ( model, Cmd.none )

                Found ->
                    -- gefunden ist gefunden -> nichts machen
                    ( model, Cmd.none )

        SetCards list ->
            setModel list 0



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
