module Elmstatic exposing
    ( Content
    , Layout
    , layout
    )

import Browser
import Element as E exposing (Element)
import Html as H exposing (Html)
import Html.Attributes as HA
import Json.Decode as JD


type alias Content a =
    { a
        | siteTitle : String
        , title : String
    }


type alias Layout =
    Program JD.Value JD.Value Never


layout : JD.Decoder (Content content) -> (Content content -> List (Element Never)) -> Layout
layout decoder view =
    Browser.document
        { init = \contentJson -> ( contentJson, Cmd.none )
        , view =
            \contentJson ->
                case JD.decodeValue decoder contentJson of
                    Err error ->
                        { title = ""
                        , body = [ htmlTemplate "Error" [ E.text (JD.errorToString error) ] ]
                        }

                    Ok content ->
                        { title = ""
                        , body = [ htmlTemplate content.siteTitle (view content) ]
                        }
        , update = \_ contentJson -> ( contentJson, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


htmlTemplate : String -> List (Element Never) -> Html Never
htmlTemplate title content =
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
            , stylesheet "/highlight/gruvbox-light.css"
            ]
        , H.node "body" [] [ E.layout [] (E.column [] content) ]
        , script "/highlight/highlight.pack.js"
        , inlineScript "hljs.initHighlightingOnLoad();"
        ]


inlineScript : String -> Html Never
inlineScript js =
    H.node "citatsmle-script" [] [ H.text js ]


script : String -> Html Never
script src =
    H.node "citatsmle-script" [ HA.attribute "src" src ] []


stylesheet : String -> Html Never
stylesheet href =
    H.node "link"
        [ HA.attribute "href" href
        , HA.attribute "rel" "stylesheet"
        ]
        []
