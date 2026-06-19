import gleam/io
import gleam/list
import gleam/result
import kitsu/anime/fetch
import kitsu/models
import loader

// import telegram_bot

pub fn main() {
  let env_load_success = loader.load_env()

  case env_load_success {
    True -> {
      let x =
        result.unwrap(
          fetch.get_anime_list(),
          models.KitsuAnimeResponse(data: []),
        )

      let first_item = result.unwrap(list.first(x.data), models.AnimeItem("2"))

      echo first_item.id
      //   telegram_bot.start()

      Ok(Nil)
    }
    False -> {
      io.println_error("Could not load some ENV variables")
      Ok(Nil)
    }
  }
}
