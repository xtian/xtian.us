module Page exposing
    ( layout
    , main
    , markdownToHtml
    )

import Element as E exposing (Element)
import Element.Region as ER
import Elmstatic
import Markdown
import Models.Page


layout : String -> List (Element Never) -> List (Element Never)
layout title contentItems =
    let
        heading =
            E.el [ ER.heading 2 ] (E.text title)
    in
    [ header
    , E.column [ ER.mainContent ] (heading :: contentItems)
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
            , githubFlavored = Just { tables = True, breaks = False }
            , sanitize = False
            , smartypants = True
            }
    in
    string
        |> Markdown.toHtmlWith mdOptions []
        |> E.html
        |> List.singleton
        |> E.paragraph []


footer : Element Never
footer =
    E.textColumn [ ER.footer ]
        [ E.paragraph []
            [ E.text "Built with "
            , E.link []
                { url = "https://github.com/alexkorban/elmstatic"
                , label = E.text "Elmstatic"
                }
            ]
        , E.paragraph []
            [ E.text "Post content licensed under "
            , E.link []
                { url = "http://creativecommons.org/licenses/by-sa/4.0"
                , label = E.text "CC BY-SA 4.0"
                }
            ]
        ]


header : Element Never
header =
    E.link []
        { url = "/"
        , label = E.el [ ER.heading 1 ] (E.text "xtian.us")
        }
