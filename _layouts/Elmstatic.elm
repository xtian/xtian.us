module Elmstatic exposing
    ( Content
    , Layout
    , Page
    , Post
    , PostList
    , decodePage
    , decodePost
    , decodePostList
    , htmlTemplate
    , inlineScript
    , layout
    , script
    , stylesheet
    )

import Browser
import Html as H exposing (Html)
import Html.Attributes as HA
import Json.Decode as JD
import Json.Decode.Pipeline as JP


type alias Post =
    { date : String
    , link : String
    , markdown : String
    , section : String
    , siteTitle : String
    , tags : List String
    , title : String
    }


type alias Page =
    { markdown : String
    , siteTitle : String
    , title : String
    }


type alias PostList =
    { posts : List Post
    , section : String
    , siteTitle : String
    , title : String
    }


type alias Content a =
    { a | siteTitle : String, title : String }


type alias Layout =
    Program JD.Value JD.Value Never


decodePage : JD.Decoder Page
decodePage =
    JD.succeed Page
        |> JP.required "markdown" JD.string
        |> JP.required "siteTitle" JD.string
        |> JP.required "title" JD.string


decodePost : JD.Decoder Post
decodePost =
    JD.succeed Post
        |> JP.required "date" JD.string
        |> JP.required "link" JD.string
        |> JP.required "markdown" JD.string
        |> JP.required "section" JD.string
        |> JP.required "siteTitle" JD.string
        |> JP.required "tags" (JD.list JD.string)
        |> JP.required "title" JD.string


decodePostList : JD.Decoder PostList
decodePostList =
    JD.succeed PostList
        |> JP.required "posts" (JD.list decodePost)
            |> JP.required "section" JD.string
            |> JP.required "siteTitle" JD.string
            |> JP.required "title" JD.string


script : String -> Html Never
script src =
    H.node "citatsmle-script" [ HA.attribute "src" src ] []


inlineScript : String -> Html Never
inlineScript js =
    H.node "citatsmle-script" [] [ H.text js ]


stylesheet : String -> Html Never
stylesheet href =
    H.node "link"
        [ HA.attribute "href" href
        , HA.attribute "rel" "stylesheet"
        ]
        []


htmlTemplate : String -> List (Html Never) -> Html Never
htmlTemplate title contentNodes =
    H.node "html"
        []
        [ H.node "head"
            []
            [ H.node "meta" [ HA.attribute "charset" "utf-8" ] []
            , H.node "title" [] [ H.text title ]
            , H.node "meta"
                [ HA.attribute "name" "description"
                , HA.attribute "content" ""
                ]
                []
            , H.node "meta"
                [ HA.attribute "name" "viewport"
                , HA.attribute "content" "width=device-width, initial-scale=1"
                ]
                []
            , stylesheet "//fonts.googleapis.com/css?family=Inconsolata"
            ]
        , H.node "body" [] contentNodes
        ]


layout : JD.Decoder (Content content) -> (Content content -> List (Html Never)) -> Layout
layout decoder view =
    Browser.document
        { init = \contentJson -> ( contentJson, Cmd.none )
        , view =
            \contentJson ->
                case JD.decodeValue decoder contentJson of
                    Err error ->
                        { title = ""
                        , body = [ htmlTemplate "Error" [ H.text <| JD.errorToString error ] ]
                        }

                    Ok content ->
                        { title = ""
                        , body = [ htmlTemplate content.siteTitle <| view content ]
                        }
        , update = \msg contentJson -> ( contentJson, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }
