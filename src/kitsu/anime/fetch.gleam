import gleam/httpc
import gleam/io
import gleam/json
import gleam/result
import kitsu/constants
import kitsu/decoders
import kitsu/models
import kitsu/req

pub fn get_anime_list() -> Result(models.KitsuAnimeResponse, httpc.HttpError) {
  use resp <- result.try(req.get("/anime"))

  case json.parse(from: resp.body, using: decoders.anime_response_decoder()) {
    Ok(res) -> Ok(res)
    Error(err) -> {
      echo err
      Ok(constants.base_anime_response)
    }
  }
}
