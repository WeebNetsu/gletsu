import gleam/dynamic/decode
import gleam/option
import kitsu/models

pub fn anime_self_link_decoder() -> decode.Decoder(models.AnimeSelfLink) {
  use self <- decode.field("self", decode.string)
  decode.success(models.AnimeSelfLink(self: self))
}

pub fn image_sizes_decoder() -> decode.Decoder(models.ImageSizes) {
  use tiny <- decode.optional_field(
    "tiny",
    option.None,
    decode.optional(decode.string),
  )
  use small <- decode.optional_field(
    "small",
    option.None,
    decode.optional(decode.string),
  )
  use medium <- decode.optional_field(
    "medium",
    option.None,
    decode.optional(decode.string),
  )
  use large <- decode.optional_field(
    "large",
    option.None,
    decode.optional(decode.string),
  )
  use original <- decode.optional_field(
    "original",
    option.None,
    decode.optional(decode.string),
  )

  decode.success(models.ImageSizes(
    tiny: tiny,
    small: small,
    medium: medium,
    large: large,
    original: original,
  ))
}

// pub fn anime_titles_decoder() -> decode.Decoder(models.AnimeTitles) {
//   use en <- decode.field("en", decode.string)
//   use en_jp <- decode.field("en_jp", decode.string)
//   use ja_jp <- decode.field("ja_jp", decode.string)

//   decode.success(models.AnimeTitles(en: en, en_jp: en_jp, ja_jp: ja_jp))
// }

pub fn relationship_link_decoder() -> decode.Decoder(models.RelationshipLink) {
  use self <- decode.optional_field(
    "self",
    option.None,
    decode.optional(decode.string),
  )
  use related <- decode.optional_field(
    "related",
    option.None,
    decode.optional(decode.string),
  )

  decode.success(models.RelationshipLink(self: self, related: related))
}

pub fn anime_relationships_decoder() -> decode.Decoder(
  models.AnimeRelationships,
) {
  use genres <- decode.optional_field(
    "genres",
    option.None,
    decode.optional(relationship_link_decoder()),
  )
  use categories <- decode.optional_field(
    "categories",
    option.None,
    decode.optional(relationship_link_decoder()),
  )
  use castings <- decode.optional_field(
    "castings",
    option.None,
    decode.optional(relationship_link_decoder()),
  )
  use installments <- decode.optional_field(
    "installments",
    option.None,
    decode.optional(relationship_link_decoder()),
  )
  use mappings <- decode.optional_field(
    "mappings",
    option.None,
    decode.optional(relationship_link_decoder()),
  )
  use reviews <- decode.optional_field(
    "reviews",
    option.None,
    decode.optional(relationship_link_decoder()),
  )
  use media_relationships <- decode.optional_field(
    "mediaRelationships",
    option.None,
    decode.optional(relationship_link_decoder()),
  )
  use characters <- decode.optional_field(
    "characters",
    option.None,
    decode.optional(relationship_link_decoder()),
  )
  use staff <- decode.optional_field(
    "staff",
    option.None,
    decode.optional(relationship_link_decoder()),
  )
  use productions <- decode.optional_field(
    "productions",
    option.None,
    decode.optional(relationship_link_decoder()),
  )
  use quotes <- decode.optional_field(
    "quotes",
    option.None,
    decode.optional(relationship_link_decoder()),
  )
  use episodes <- decode.optional_field(
    "episodes",
    option.None,
    decode.optional(relationship_link_decoder()),
  )
  use streaming_links <- decode.optional_field(
    "streamingLinks",
    option.None,
    decode.optional(relationship_link_decoder()),
  )
  use anime_productions <- decode.optional_field(
    "animeProductions",
    option.None,
    decode.optional(relationship_link_decoder()),
  )
  use anime_characters <- decode.optional_field(
    "animeCharacters",
    option.None,
    decode.optional(relationship_link_decoder()),
  )
  use anime_staff <- decode.optional_field(
    "animeStaff",
    option.None,
    decode.optional(relationship_link_decoder()),
  )

  decode.success(models.AnimeRelationships(
    genres: genres,
    categories: categories,
    castings: castings,
    installments: installments,
    mappings: mappings,
    reviews: reviews,
    media_relationships: media_relationships,
    characters: characters,
    staff: staff,
    productions: productions,
    quotes: quotes,
    episodes: episodes,
    streaming_links: streaming_links,
    anime_productions: anime_productions,
    anime_characters: anime_characters,
    anime_staff: anime_staff,
  ))
}

pub fn anime_attributes_decoder() -> decode.Decoder(models.AnimeAttributes) {
  use created_at <- decode.optional_field(
    "createdAt",
    option.None,
    decode.optional(decode.string),
  )
  use updated_at <- decode.optional_field(
    "updatedAt",
    option.None,
    decode.optional(decode.string),
  )
  use slug <- decode.optional_field(
    "slug",
    option.None,
    decode.optional(decode.string),
  )
  use synopsis <- decode.optional_field(
    "synopsis",
    option.None,
    decode.optional(decode.string),
  )
  use description <- decode.optional_field(
    "description",
    option.None,
    decode.optional(decode.string),
  )
  use canonical_title <- decode.optional_field(
    "canonicalTitle",
    option.None,
    decode.optional(decode.string),
  )
  use abbreviated_titles <- decode.optional_field(
    "abbreviatedTitles",
    option.None,
    decode.optional(decode.list(of: decode.string)),
  )
  use average_rating <- decode.optional_field(
    "averageRating",
    option.None,
    decode.optional(decode.string),
  )
  use user_count <- decode.optional_field(
    "userCount",
    option.None,
    decode.optional(decode.int),
  )
  use favorites_count <- decode.optional_field(
    "favoritesCount",
    option.None,
    decode.optional(decode.int),
  )
  use start_date <- decode.optional_field(
    "startDate",
    option.None,
    decode.optional(decode.string),
  )
  use end_date <- decode.optional_field(
    "endDate",
    option.None,
    decode.optional(decode.string),
  )
  use popularity_rank <- decode.optional_field(
    "popularityRank",
    option.None,
    decode.optional(decode.int),
  )
  use rating_rank <- decode.optional_field(
    "ratingRank",
    option.None,
    decode.optional(decode.int),
  )
  use age_rating <- decode.optional_field(
    "ageRating",
    option.None,
    decode.optional(decode.string),
  )
  use age_rating_guide <- decode.optional_field(
    "ageRatingGuide",
    option.None,
    decode.optional(decode.string),
  )
  use subtype <- decode.optional_field(
    "subtype",
    option.None,
    decode.optional(decode.string),
  )
  use status <- decode.optional_field(
    "status",
    option.None,
    decode.optional(decode.string),
  )
  use episode_count <- decode.optional_field(
    "episodeCount",
    option.None,
    decode.optional(decode.int),
  )
  use episode_length <- decode.optional_field(
    "episodeLength",
    option.None,
    decode.optional(decode.int),
  )
  use total_length <- decode.optional_field(
    "totalLength",
    option.None,
    decode.optional(decode.int),
  )
  use youtube_video_id <- decode.optional_field(
    "youtubeVideoId",
    option.None,
    decode.optional(decode.string),
  )
  use show_type <- decode.optional_field(
    "showType",
    option.None,
    decode.optional(decode.string),
  )
  use nsfw <- decode.optional_field(
    "nsfw",
    option.None,
    decode.optional(decode.bool),
  )
  use poster_image <- decode.optional_field(
    "posterImage",
    option.None,
    decode.optional(image_sizes_decoder()),
  )
  use cover_image <- decode.optional_field(
    "coverImage",
    option.None,
    decode.optional(image_sizes_decoder()),
  )

  decode.success(models.AnimeAttributes(
    created_at: created_at,
    updated_at: updated_at,
    slug: slug,
    synopsis: synopsis,
    description: description,
    canonical_title: canonical_title,
    abbreviated_titles: abbreviated_titles,
    average_rating: average_rating,
    user_count: user_count,
    favorites_count: favorites_count,
    start_date: start_date,
    end_date: end_date,
    popularity_rank: popularity_rank,
    rating_rank: rating_rank,
    age_rating: age_rating,
    age_rating_guide: age_rating_guide,
    subtype: subtype,
    status: status,
    episode_count: episode_count,
    episode_length: episode_length,
    total_length: total_length,
    youtube_video_id: youtube_video_id,
    show_type: show_type,
    nsfw: nsfw,
    poster_image: poster_image,
    cover_image: cover_image,
  ))
}

pub fn anime_item_decoder() -> decode.Decoder(models.AnimeItem) {
  use id <- decode.field("id", decode.string)
  use item_type <- decode.field("type", decode.string)
  use links <- decode.field("links", anime_self_link_decoder())
  use attributes <- decode.optional_field(
    "attributes",
    option.None,
    decode.optional(anime_attributes_decoder()),
  )
  use relationships <- decode.optional_field(
    "relationships",
    option.None,
    decode.optional(anime_relationships_decoder()),
  )

  decode.success(models.AnimeItem(
    id: id,
    item_type: item_type,
    links: links,
    attributes: attributes,
    relationships: relationships,
  ))
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
