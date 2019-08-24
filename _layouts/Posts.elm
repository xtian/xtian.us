module Posts exposing (main)

import Element as E
import Elmstatic
import Models.PostList
import Page
import Post


main : Elmstatic.Layout
main =
    let
        postItem post =
            --div []
            --    [ a [ href ("/" ++ post.link) ] [ h2 [] [ text post.title ] ]
            --    , Post.metadataHtml post
            --    ]
            E.column []
                [ E.text post.title
                , Post.metadataHtml post
                ]
    in
    Elmstatic.layout Models.PostList.decode <|
        \{ posts, title } ->
            posts
                |> List.sortBy .date
                |> List.reverse
                |> List.map postItem
                |> Page.layout title
