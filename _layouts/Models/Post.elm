module Models.Post exposing
    ( Post
    , decode
    )

import Json.Decode as JD
import Json.Decode.Pipeline as JP


type alias Post =
    { date : String
    , link : String
    , markdown : String
    , section : String
    , siteTitle : String
    , tags : List String
    , title : String
    }


decode : JD.Decoder Post
decode =
    JD.succeed Post
        |> JP.required "date" JD.string
        |> JP.required "link" JD.string
        |> JP.required "markdown" JD.string
        |> JP.required "section" JD.string
        |> JP.required "siteTitle" JD.string
        |> JP.required "tags" (JD.list JD.string)
        |> JP.required "title" JD.string
