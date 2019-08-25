module Posts exposing (main)

import Element as E
import Element.Region as ER
import Elmstatic
import Models.PostList
import Page
import Post


main : Elmstatic.Layout
main =
    let
        postItem post =
            let
                title =
                    E.link []
                        { url = "/" ++ post.link
                        , label = E.el [ ER.heading 2 ] (E.text post.title)
                        }
            in
            E.column [] (title :: Post.partial post)
    in
    Elmstatic.layout Models.PostList.decode <|
        \{ posts, title } ->
            posts
                |> List.sortBy .date
                |> List.reverse
                |> List.map postItem
                |> Page.layout Nothing
