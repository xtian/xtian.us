module Post exposing
    ( main
    , metadataHtml
    )

import Element as E exposing (Element)
import Elmstatic
import Models.Post exposing (Post)
import Page


main : Elmstatic.Layout
main =
    Elmstatic.layout Models.Post.decode <|
        \content ->
            Page.layout
                content.title
                [ metadataHtml content, Page.markdownToHtml content.markdown ]


metadataHtml : Post -> Element Never
metadataHtml { date, tags } =
    let
        tagToHtml tag =
            E.link []
                { url = "/tags/" ++ String.toLower tag
                , label = E.text tag
                }

        tagsHtml =
            List.map tagToHtml tags

        rest =
            if List.isEmpty tagsHtml then
                []

            else
                E.text " - " :: tagsHtml
    in
    E.row [] (E.text date :: rest)
