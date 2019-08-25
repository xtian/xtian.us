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
            E.column []
                [ E.link [] { url = "/" ++ post.link, label = E.text post.title }
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
