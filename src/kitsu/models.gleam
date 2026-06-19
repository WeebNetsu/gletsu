pub type AnimeItem {
  AnimeItem(id: String, item_type: String)
}

pub type KitsuAnimeResponseMeta {
  KitsuAnimeResponseMeta(count: Int)
}

pub type KitsuAnimeResponsePagination {
  KitsuAnimeResponsePagination(first: String, next: String, last: String)
}

pub type KitsuAnimeResponse {
  KitsuAnimeResponse(
    data: List(AnimeItem),
    meta: KitsuAnimeResponseMeta,
    links: KitsuAnimeResponsePagination,
  )
}
