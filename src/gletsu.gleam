import dot_env
import dot_env/env
import gleam/erlang/node
import gleam/io
import gleam/list
import gleam/option
import gleam/otp/actor
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
  case load_env() {
    True -> {
      let assert Ok(bot_actor) =
        actor.new(telegram_bot.BotState(
          last_command: option.None,
          user_id: option.None,
          chat_id: option.None,
          page: option.None,
        ))
        |> actor.on_message(telegram_bot.handle_actor_message)
        |> actor.start

      telegram_bot.start(bot_actor)

      Ok(Nil)
    }
    False -> {
      io.println_error("Could not load some ENV variables")
      Ok(Nil)
    }
  }
}
