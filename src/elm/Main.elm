module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (keyCode, on, onClick, onInput)
import Json.Decode as Json
import SimpleAST exposing (Expr(..))
import SimpleParser exposing (parse)


--import SimpleEvaluator exposing (eval)


type Msg
    = NoOp
    | UpdateString String
    | ParseString
    | KeyDown Int


type alias Model =
    { ast : Maybe Expr
    , textInput : Maybe String
    }


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }


model : Model
model =
    { ast = Nothing --Just (Add (Num 2) (Num 3))
    , textInput = Nothing
    }


view : Model -> Html Msg
view model =
    div [ class "page" ]
        [ viewContent model
        ]


viewContent : Model -> Html Msg
viewContent model =
    div [ class "content" ]
        [ div [ class "input-container" ]
            [ textInput
            , button [ class "button btn", onClick ParseString ] [ text "Parse" ]
            ]
        , div [ class "result-container" ]
            [ h3 [] [ text "Expr: " ]
            , astToString model.ast
                |> text
            ]
        ]


textInput : Html Msg
textInput =
    input
        [ class "input"
        , placeholder "Skriv inn uttrykk"
        , onInput UpdateString
        , onKeyDown KeyDown
        ]
        []


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        UpdateString inp ->
            { model
                | textInput =
                    if String.isEmpty inp then
                        Nothing
                    else
                        Just inp
            }

        ParseString ->
            parseString model

        KeyDown key ->
            if key == 13 then
                parseString model
            else
                model


parseString : Model -> Model
parseString model =
    let
        newAST =
            Maybe.map parse model.textInput
    in
    { model | ast = newAST }



--<| eval "function foo x y = x + y; foo (3,4);"
-- HELPERS


astToString : Maybe Expr -> String
astToString mAST =
    case mAST of
        Just ast ->
            toString ast

        Nothing ->
            "..."


onKeyDown : (Int -> Msg) -> Attribute Msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)
