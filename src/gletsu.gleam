import dot_env
import dot_env/env
import gleam/io
import gleam/list
import gletsu/telegram_bot

/// Load initial important env files, false if failed
pub fn load_env() -> Bool {
  dot_env.new()
  |> dot_env.set_path("./.env")
  |> dot_env.set_debug(False)
  |> dot_env.load

  list.map(["BOT_TOKEN", "API_URL"], fn(var) {
    case env.get_string(var) {
      Ok(_) -> True
      Error(err) -> {
        io.println_error("something went wrong: " <> err)
        False
      }
    }
  })
  |> list.all(fn(val) { val == True })
}

pub fn main() {
  let env_load_success = load_env()

  case env_load_success {
    True -> {
      telegram_bot.start()

      Ok(Nil)
    }
    False -> {
      io.println_error("Could not load some ENV variables")
      Ok(Nil)
    }
  }
}
