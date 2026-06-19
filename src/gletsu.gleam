import gleam/io
import gleam/list
import gleam/result
import kitsu/anime/fetch
import kitsu/constants
import loader

pub fn main() {
  let env_load_success = loader.load_env()

  case env_load_success {
    True -> {
      let anime =
        result.unwrap(fetch.get_anime_list(), constants.base_anime_response)

      let first_item =
        result.unwrap(list.first(anime.data), constants.base_anime_item)

      echo first_item.id
      echo anime.meta.count
      echo anime.links.first
      //   telegram_bot.start()

      Ok(Nil)
    }
    False -> {
      io.println_error("Could not load some ENV variables")
      Ok(Nil)
    }
  }
}
