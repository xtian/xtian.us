module Page exposing
    ( footer
    , header
    , layout
    , main
    , markdownToHtml
    )

import Element as E exposing (Element)
import Elmstatic
import Markdown
import Models.Page


markdownToHtml : String -> Element Never
markdownToHtml string =
    let
        mdOptions : Markdown.Options
        mdOptions =
            { defaultHighlighting = Nothing
            , githubFlavored = Just { tables = False, breaks = False }
            , sanitize = False
            , smartypants = True
            }
    in
    string
        |> Markdown.toHtmlWith mdOptions []
        |> E.html


header : Element Never
header =
    E.none


footer : Element Never
footer =
    E.none


layout : String -> List (Element Never) -> List (Element Never)
layout title contentItems =
    [ header
    , E.column [] ([ E.el [] (E.text title) ] ++ contentItems)
    , footer
    ]


main : Elmstatic.Layout
main =
    Elmstatic.layout Models.Page.decode <|
        \{ title, markdown } ->
            layout title [ markdownToHtml markdown ]
