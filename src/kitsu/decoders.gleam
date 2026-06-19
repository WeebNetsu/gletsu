import gleam/dynamic/decode
import kitsu/models

pub fn anime_item_decoder() -> decode.Decoder(models.AnimeItem) {
  use id <- decode.field("id", decode.string)
  decode.success(models.AnimeItem(id))
}

pub fn anime_response_decoder() -> decode.Decoder(models.KitsuAnimeResponse) {
  use data <- decode.field("data", decode.list(of: anime_item_decoder()))
  decode.success(models.KitsuAnimeResponse(data: data))
}
