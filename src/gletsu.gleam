import gleam/io
import loader
import telegram_bot

pub fn main() {
  let env_load_success = loader.load_env()

  case env_load_success {
    True -> {
      telegram_bot.start()
    }
    False -> {
      io.println_error("Could not load some ENV variables")
    }
  }
}
