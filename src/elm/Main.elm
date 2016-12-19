module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Layout.Layout exposing (layout)
import Page.Home.View
import Page.About.View
import Navigation


-- APP


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { location = location
      , home = Page.Home.View.model
      }
    , Cmd.none
    )



-- Model


type alias Model =
    { location : Navigation.Location
    , home : Page.Home.View.Model
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE


type Msg
    = UrlChange Navigation.Location
    | HomeMsg Page.Home.View.Msg
    | Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            ( { model | location = location }
            , Cmd.none
            )

        HomeMsg subMsg ->
            ( { model | home = Page.Home.View.update subMsg model.home }, Cmd.none )

        Noop ->
            ( model, Cmd.none )



-- Router


router : Navigation.Location -> Model -> Html Msg
router location model =
    if model.location.hash == "#/about" then
        Html.map (\x -> Noop) (Page.About.View.view Page.About.View.None)
    else if model.location.hash == "#/home" then
        Html.map HomeMsg (Page.Home.View.view model.home)
    else
        Html.map HomeMsg (Page.Home.View.view model.home)



-- VIEW


view : Model -> Html Msg
view model =
    let
        view =
            router model.location model
    in
        layout
            (div [ class "main-content" ]
                [ div [] [ view ]
                ]
            )
