import gleam/dict
import gleam/io
import gleam/list
import gleam/result
import kitsu/anime
import loader

pub fn main() {
  let env_load_success = loader.load_env()

  case env_load_success {
    True -> {
      let x =
        result.unwrap(
          anime.get_anime_list(),
          anime.KitsuAnimeResponse(data: []),
        )

      let first_item = result.unwrap(list.first(x.data), dict.new())

      echo dict.get(first_item, "id")
      //   telegram_bot.start()

      Ok(Nil)
    }
    False -> {
      io.println_error("Could not load some ENV variables")
      Ok(Nil)
    }
  }
}
