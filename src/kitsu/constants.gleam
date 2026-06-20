import gleam/option
import kitsu/models

pub const base_anime_item = models.AnimeItem(
  id: "1",
  item_type: "anime",
  links: models.AnimeSelfLink(""),
  attributes: option.None,
  relationships: option.None,
)

pub const base_anime_response = models.KitsuAnimeResponse(
  data: [base_anime_item],
  meta: models.KitsuAnimeResponseMeta(count: 1),
  links: models.KitsuAnimeResponsePagination(first: "", next: "", last: ""),
)
