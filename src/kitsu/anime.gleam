import dot_env/env
import gleam/dict
import gleam/dynamic
import gleam/dynamic/decode
import gleam/http/request
import gleam/http/response
import gleam/httpc
import gleam/json
import gleam/result

pub type KitsuAnimeResponse {
  KitsuAnimeResponse(data: List(dict.Dict(String, dynamic.Dynamic)))
}

pub fn cat_from_json(
  json_string: String,
) -> Result(KitsuAnimeResponse, json.DecodeError) {
  let cat_decoder = {
    use data <- decode.field(
      "data",
      decode.list(of: decode.dict(decode.string, decode.dynamic)),
    )
    decode.success(KitsuAnimeResponse(data: data))
  }
  json.parse(from: json_string, using: cat_decoder)
}

pub fn get_anime_list() {
  let assert Ok(base_req) =
    request.to(result.unwrap(env.get_string("API_URL"), "") <> "/anime")

  let req =
    request.prepend_header(base_req, "accept", "application/vnd.api+json")

  // Send the HTTP request to the server
  use resp <- result.try(httpc.send(req))

  // We get a response record back
  //   assert resp.status == 200

  let content_type = response.get_header(resp, "content-type")
  assert content_type == Ok("application/vnd.api+json")

  Ok(result.unwrap(cat_from_json(resp.body), KitsuAnimeResponse(data: [])))
}
