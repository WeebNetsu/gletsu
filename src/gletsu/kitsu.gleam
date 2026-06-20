import dot_env/env
import gleam/dynamic/decode
import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/httpc
import gleam/io
import gleam/json
import gleam/option
import gleam/result

// ------------- MARK: Types
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

// ------------- MARK: Base Constants

pub const base_anime_item = AnimeItem(
  id: "1",
  item_type: "anime",
  links: AnimeSelfLink(""),
  attributes: option.None,
  relationships: option.None,
)

pub const base_anime_response = KitsuAnimeResponse(
  data: [base_anime_item],
  meta: KitsuAnimeResponseMeta(count: 1),
  links: KitsuAnimeResponsePagination(first: "", next: "", last: ""),
)

// ------------- MARK: Util Methods

pub fn http_get_request(
  endpoint: String,
) -> Result(response.Response(String), Nil) {
  let api_url = result.unwrap(env.get_string("API_URL"), "")

  use base_req <- result.try(request.to(api_url <> endpoint))

  let req =
    request.set_method(base_req, http.Get)
    |> request.prepend_header("accept", "application/vnd.api+json")

  // Send the HTTP request to the server
  case httpc.send(req) {
    Ok(resp) -> {
      let content_type = response.get_header(resp, "content-type")
      assert content_type == Ok("application/vnd.api+json")

      Ok(resp)
    }
    Error(_) -> {
      io.print_error("Could not make get request")
      Error(Nil)
    }
  }
  //   case request.to(api_url <> endpoint) {
  //     Ok(base_req) -> {
  //   let req =
  //     request.set_method(base_req, http.Get)
  //     |> request.prepend_header("accept", "application/vnd.api+json")

  // // Send the HTTP request to the server
  // result.try(httpc.send(req), fn(resp) {
  //   let content_type = response.get_header(resp, "content-type")
  //   assert content_type == Ok("application/vnd.api+json")

  //   Ok(resp)
  // })
  //     }
  //     Error(_) -> {
  //       io.print_error("Could not make request to api")
  //     //   how do I handle httpc.httperror?
  //       Ok("???")
  //     }
  //   }
}

// ------------- MARK: Decoders

pub fn anime_self_link_decoder() -> decode.Decoder(AnimeSelfLink) {
  use self <- decode.field("self", decode.string)
  decode.success(AnimeSelfLink(self: self))
}

pub fn image_sizes_decoder() -> decode.Decoder(ImageSizes) {
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

  decode.success(ImageSizes(
    tiny: tiny,
    small: small,
    medium: medium,
    large: large,
    original: original,
  ))
}

pub fn relationship_link_decoder() -> decode.Decoder(RelationshipLink) {
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

  decode.success(RelationshipLink(self: self, related: related))
}

pub fn anime_relationships_decoder() -> decode.Decoder(AnimeRelationships) {
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

  decode.success(AnimeRelationships(
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

pub fn anime_attributes_decoder() -> decode.Decoder(AnimeAttributes) {
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

  decode.success(AnimeAttributes(
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

pub fn anime_item_decoder() -> decode.Decoder(AnimeItem) {
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

  decode.success(AnimeItem(
    id: id,
    item_type: item_type,
    links: links,
    attributes: attributes,
    relationships: relationships,
  ))
}

pub fn anime_response_meta_decoder() -> decode.Decoder(KitsuAnimeResponseMeta) {
  use count <- decode.field("count", decode.int)
  decode.success(KitsuAnimeResponseMeta(count: count))
}

pub fn anime_response_pagination_decoder() -> decode.Decoder(
  KitsuAnimeResponsePagination,
) {
  use first <- decode.field("first", decode.string)
  use next <- decode.field("next", decode.string)
  use last <- decode.field("last", decode.string)

  decode.success(KitsuAnimeResponsePagination(first:, next:, last:))
}

pub fn anime_response_decoder() -> decode.Decoder(KitsuAnimeResponse) {
  use data <- decode.field("data", decode.list(of: anime_item_decoder()))
  use meta <- decode.field("meta", anime_response_meta_decoder())
  use links <- decode.field("links", anime_response_pagination_decoder())

  decode.success(KitsuAnimeResponse(data: data, meta: meta, links: links))
}

// ------------- MARK: Requests

pub fn get_anime_list() -> Result(KitsuAnimeResponse, Nil) {
  use resp <- result.try(http_get_request("/anime"))

  case json.parse(from: resp.body, using: anime_response_decoder()) {
    Ok(res) -> Ok(res)
    Error(err) -> {
      echo err
      Ok(base_anime_response)
    }
  }
}
