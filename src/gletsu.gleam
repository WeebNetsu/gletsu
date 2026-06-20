import gleam/io
import gleam/list
import gleam/option
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

      case first_item.attributes {
        option.Some(val) -> {
          echo val.canonical_title
          Nil
        }
        _ -> {
          echo "Nothing"
          Nil
        }
      }

      //   telegram_bot.start()

      Ok(Nil)
    }
    False -> {
      io.println_error("Could not load some ENV variables")
      Ok(Nil)
    }
  }
}
