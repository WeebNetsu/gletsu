import dot_env/env
import gleam/erlang/process
import gleam/result
import telega
import telega/reply
import telega/router
import telega/update
import telega_httpc

fn handle_text(ctx, text) {
  use ctx <- telega.log_context(ctx, "echo_text")
  let assert Ok(_) = reply.with_text(ctx, text)
  Ok(ctx)
}

fn handle_command(ctx, command: update.Command) {
  use ctx <- telega.log_context(ctx, "echo_command")
  let assert Ok(_) = reply.with_text(ctx, "MY Command: " <> command.text)
  Ok(ctx)
}

fn build_routes() {
  router.new("Gletsu")
  |> router.on_any_text(handle_text)
  |> router.on_commands(["start", "help"], handle_command)
}

pub fn start() {
  let bot_token = result.unwrap(env.get_string("BOT_TOKEN"), "")
  let router = build_routes()

  let assert Ok(_bot) =
    telega_httpc.new(bot_token)
    |> telega.new_for_polling
    |> telega.with_router(router)
    |> telega.init_for_polling_nil_session()

  process.sleep_forever()
}
