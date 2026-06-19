import gleam/dynamic/decode
import kitsu/models

pub fn anime_item_decoder() -> decode.Decoder(models.AnimeItem) {
  use id <- decode.field("id", decode.string)
  use item_type <- decode.field("type", decode.string)

  decode.success(models.AnimeItem(id: id, item_type: item_type))
}

pub fn anime_response_meta_decoder() -> decode.Decoder(
  models.KitsuAnimeResponseMeta,
) {
  use count <- decode.field("count", decode.int)

  decode.success(models.KitsuAnimeResponseMeta(count: count))
}

pub fn anime_response_pagination_decoder() -> decode.Decoder(
  models.KitsuAnimeResponsePagination,
) {
  use first <- decode.field("first", decode.string)
  use next <- decode.field("next", decode.string)
  use last <- decode.field("last", decode.string)

  decode.success(models.KitsuAnimeResponsePagination(
    first: first,
    next: next,
    last: last,
  ))
}

pub fn anime_response_decoder() -> decode.Decoder(models.KitsuAnimeResponse) {
  use data <- decode.field("data", decode.list(of: anime_item_decoder()))
  use meta <- decode.field("meta", anime_response_meta_decoder())
  use links <- decode.field("links", anime_response_pagination_decoder())

  decode.success(models.KitsuAnimeResponse(data: data, meta: meta, links: links))
}
