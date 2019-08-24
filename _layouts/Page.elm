module Page exposing
    ( layout
    , main
    , markdownToHtml
    )

import Element as E exposing (Element)
import Elmstatic
import Markdown
import Models.Page


layout : String -> List (Element Never) -> List (Element Never)
layout title contentItems =
    [ header
    , E.column [] (E.el [] (E.text title) :: contentItems)
    , footer
    ]


main : Elmstatic.Layout
main =
    Elmstatic.layout Models.Page.decode <|
        \{ title, markdown } ->
            layout title [ markdownToHtml markdown ]


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


footer : Element Never
footer =
    E.none


header : Element Never
header =
    E.none
