import dot_env/env
import gleam/erlang/process
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import gletsu/kitsu
import telega
import telega/bot
import telega/reply
import telega/router
import telega/update
import telega_httpc

fn handle_text(ctx, text) {
  use ctx <- telega.log_context(ctx, "echo_text")
  let assert Ok(_) = reply.with_text(ctx, text)
  Ok(ctx)
}

fn handle_list_anime_command(ctx: bot.Context(a, b)) {
  let anime = kitsu.get_anime_list()

  case anime {
    Ok(res) -> {
      let anime_list =
        list.map(res.data, fn(anime_item: kitsu.AnimeItem) {
          let canonical_title = case
            option.to_result(anime_item.attributes, "attributes do not exist")
          {
            Ok(attributes) -> {
              option.unwrap(attributes.canonical_title, "N/A")
            }
            Error(err) -> {
              io.print_error(err)
              "N/A"
            }
          }

          anime_item.id <> " - " <> canonical_title
        })

      case list.is_empty(anime_list) {
        True -> {
          case
            reply.with_text(
              ctx,
              "Failed to list anime - could not generate list",
            )
          {
            Ok(_) -> Nil
            Error(_) -> {
              io.print_error("Fetched list was empty")
            }
          }
        }
        False -> Nil
      }

      case reply.with_text(ctx, string.join(anime_list, "\n")) {
        Ok(_) -> Nil
        Error(err) -> {
          echo err
          io.print_error("Could not send with text")
        }
      }
    }
    Error(_) -> {
      case reply.with_text(ctx, "Failed to list anime. Is Kitsu down?") {
        Ok(_) -> Nil
        Error(_) -> {
          io.print_error("Could not send with text")
        }
      }
    }
  }
}

fn handle_command(ctx: bot.Context(a, b), command: update.Command) {
  use ctx <- telega.log_context(ctx, "handle_command")

  case command.text {
    "/search" -> handle_list_anime_command(ctx)
    "/search" <> search_term -> {
      let cleaned_search = string.trim(search_term)
      let assert Ok(_) =
        reply.with_text(ctx, "Yes let me search " <> cleaned_search)
      Nil
    }
    _ -> {
      let assert Ok(_) =
        reply.with_text(ctx, "Unknown command: " <> command.text)
      Nil
    }
  }

  Ok(ctx)
}

fn build_routes() {
  router.new("Gletsu")
  |> router.on_any_text(handle_text)
  |> router.on_commands(["search"], handle_command)
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
