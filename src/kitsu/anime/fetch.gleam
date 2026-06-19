import gleam/httpc
import gleam/json
import gleam/result
import kitsu/constants
import kitsu/decoders
import kitsu/models
import kitsu/req

pub fn get_anime_list() -> Result(models.KitsuAnimeResponse, httpc.HttpError) {
  use resp <- result.try(req.get("/anime"))

  Ok(result.unwrap(
    json.parse(from: resp.body, using: decoders.anime_response_decoder()),
    constants.base_anime_response,
  ))
}
