module Models.Page exposing
    ( Page
    , decode
    )

import Json.Decode as JD
import Json.Decode.Pipeline as JP


type alias Page =
    { markdown : String
    , siteTitle : String
    , title : String
    }


decode : JD.Decoder Page
decode =
    JD.succeed Page
        |> JP.required "markdown" JD.string
        |> JP.required "siteTitle" JD.string
        |> JP.required "title" JD.string
