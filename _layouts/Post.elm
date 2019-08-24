module Post exposing
    ( main
    , metadataHtml
    )

import Element as E exposing (Element)
import Elmstatic
import Models.Post exposing (Post)
import Page


tagsToHtml : List String -> List (Element Never)
tagsToHtml tags =
    let
        toLink tag =
            E.link []
                { url = "/tags/" ++ String.toLower tag
                , label = E.text tag
                }
    in
    List.map toLink tags


metadataHtml : Post -> Element Never
metadataHtml { date, tags } =
    E.column []
        ([ E.text date
         , E.text "•"
         ]
            ++ tagsToHtml tags
        )


main : Elmstatic.Layout
main =
    Elmstatic.layout Models.Post.decode <|
        \content ->
            Page.layout
                content.title
                [ metadataHtml content, Page.markdownToHtml content.markdown ]
