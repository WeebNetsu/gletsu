import gleam/option

pub type AnimeItem {
  AnimeItem(
    id: String,
    // Using 'type' directly is fine, but 'item_type' avoids confusion
    item_type: String,
    links: AnimeSelfLink,
    attributes: option.Option(AnimeAttributes),
    relationships: option.Option(AnimeRelationships),
  )
}

pub type AnimeSelfLink {
  AnimeSelfLink(self: String)
}

pub type ImageSizes {
  ImageSizes(
    tiny: option.Option(String),
    small: option.Option(String),
    medium: option.Option(String),
    large: option.Option(String),
    original: option.Option(String),
  )
}

pub type AnimeTitles {
  AnimeTitles(en: String, en_jp: String, ja_jp: String)
}

pub type AnimeAttributes {
  AnimeAttributes(
    created_at: option.Option(String),
    updated_at: option.Option(String),
    slug: option.Option(String),
    synopsis: option.Option(String),
    description: option.Option(String),
    canonical_title: option.Option(String),
    abbreviated_titles: option.Option(List(String)),
    average_rating: option.Option(String),
    user_count: option.Option(Int),
    favorites_count: option.Option(Int),
    start_date: option.Option(String),
    end_date: option.Option(String),
    popularity_rank: option.Option(Int),
    rating_rank: option.Option(Int),
    age_rating: option.Option(String),
    age_rating_guide: option.Option(String),
    subtype: option.Option(String),
    status: option.Option(String),
    episode_count: option.Option(Int),
    episode_length: option.Option(Int),
    total_length: option.Option(Int),
    youtube_video_id: option.Option(String),
    show_type: option.Option(String),
    nsfw: option.Option(Bool),
    poster_image: option.Option(ImageSizes),
    cover_image: option.Option(ImageSizes),
  )
}

pub type RelationshipLink {
  RelationshipLink(self: option.Option(String), related: option.Option(String))
}

pub type AnimeRelationships {
  AnimeRelationships(
    genres: option.Option(RelationshipLink),
    categories: option.Option(RelationshipLink),
    castings: option.Option(RelationshipLink),
    installments: option.Option(RelationshipLink),
    mappings: option.Option(RelationshipLink),
    reviews: option.Option(RelationshipLink),
    media_relationships: option.Option(RelationshipLink),
    characters: option.Option(RelationshipLink),
    staff: option.Option(RelationshipLink),
    productions: option.Option(RelationshipLink),
    quotes: option.Option(RelationshipLink),
    episodes: option.Option(RelationshipLink),
    streaming_links: option.Option(RelationshipLink),
    anime_productions: option.Option(RelationshipLink),
    anime_characters: option.Option(RelationshipLink),
    anime_staff: option.Option(RelationshipLink),
  )
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
