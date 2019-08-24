module Models.PostList exposing
    ( PostList
    , decode
    )

import Json.Decode as JD
import Json.Decode.Pipeline as JP
import Models.Post as Post exposing (Post)


type alias PostList =
    { posts : List Post
    , section : String
    , siteTitle : String
    , title : String
    }


decode : JD.Decoder PostList
decode =
    JD.succeed PostList
        |> JP.required "posts" (JD.list Post.decode)
        |> JP.required "section" JD.string
        |> JP.required "siteTitle" JD.string
        |> JP.required "title" JD.string
