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
import telega/format
import telega/model/types
import telega/reply
import telega/router
import telega/update
import telega_httpc

pub type BotError {
  /// empty arrays
  EmptyResultError
  /// usually if an optional result is nil
  NoValueError
  /// could not make request, usually because a kitsu error was given
  FailedRequestError
  /// could not complete a telegram request
  TelegramError
}

fn handle_text(ctx, text) {
  use ctx <- telega.log_context(ctx, "echo_text")
  let assert Ok(_) = reply.with_text(ctx, text)
  Ok(ctx)
}

fn handle_list_anime_command(ctx: bot.Context(a, b)) -> Result(Nil, BotError) {
  use anime <- result.try(
    kitsu.get_anime_list() |> result.map_error(fn(_) { FailedRequestError }),
  )

  let anime_list =
    list.map(anime.data, fn(anime_item: kitsu.AnimeItem) {
      let canonical_title = case
        option.to_result(anime_item.attributes, "attributes do not exist")
      {
        Ok(attributes) -> {
          option.unwrap(attributes.canonical_title, "N/A")
        }
        Error(err) -> {
          io.println_error(err)
          "N/A"
        }
      }

      anime_item.id <> " - " <> canonical_title
    })

  case anime_list {
    // will match an empty list
    [] -> {
      use _ <- result.try(
        reply.with_text(ctx, "Failed to list anime - could not generate list")
        |> result.map_error(fn(_) { TelegramError }),
      )

      Error(EmptyResultError)
    }
    rest -> {
      let formatted =
        format.build()
        |> format.bold_text("Select An Anime")
        |> format.to_formatted()

      use _ <- result.try(
        reply.with_formatted_markup(
          ctx,
          formatted,
          types.SendMessageReplyReplyKeyboardMarkupParameters(
            types.ReplyKeyboardMarkup(
              input_field_placeholder: option.None,
              is_persistent: option.None,
              keyboard: [
                [
                  types.KeyboardButton(
                    text: "Previous Page",
                    icon_custom_emoji_id: option.None,
                    request_chat: option.None,
                    request_contact: option.None,
                    request_location: option.None,
                    request_managed_bot: option.None,
                    request_poll: option.None,
                    request_users: option.None,
                    style: option.None,
                    web_app: option.None,
                  ),
                  types.KeyboardButton(
                    text: "Quit",
                    icon_custom_emoji_id: option.None,
                    request_chat: option.None,
                    request_contact: option.None,
                    request_location: option.None,
                    request_managed_bot: option.None,
                    request_poll: option.None,
                    request_users: option.None,
                    style: option.None,
                    web_app: option.None,
                  ),
                  types.KeyboardButton(
                    text: "Next Page",
                    icon_custom_emoji_id: option.None,
                    request_chat: option.None,
                    request_contact: option.None,
                    request_location: option.None,
                    request_managed_bot: option.None,
                    request_poll: option.None,
                    request_users: option.None,
                    style: option.None,
                    web_app: option.None,
                  ),
                ],
                ..list.map(rest, fn(title) {
                  [
                    types.KeyboardButton(
                      text: title,
                      icon_custom_emoji_id: option.None,
                      request_chat: option.None,
                      request_contact: option.None,
                      request_location: option.None,
                      request_managed_bot: option.None,
                      request_poll: option.None,
                      request_users: option.None,
                      style: option.None,
                      web_app: option.None,
                    ),
                  ]
                })
              ],
              one_time_keyboard: option.None,
              resize_keyboard: option.None,
              selective: option.None,
            ),
          ),
        )
        |> result.map_error(fn(err) {
          echo err
          io.println_error("Could not send with text")
          TelegramError
        }),
      )

      Ok(Nil)
    }
  }
}

fn handle_command_error_display(err: BotError) -> Nil {
  case err {
    TelegramError ->
      io.println_error("A telegram request failed. Could not execute command")
    NoValueError | EmptyResultError ->
      io.println_error(
        "An empty error value error has caused no result to be returned",
      )
    FailedRequestError ->
      io.println_error(
        "Failed to make some requests. This is most likely related to Kitsu",
      )
    // _ -> io.println_error("")
  }
}

fn handle_command(
  ctx: bot.Context(a, b),
  command: update.Command,
) -> Result(bot.Context(a, b), b) {
  use ctx <- telega.log_context(ctx, "handle_command")

  case command.text {
    "/search" -> {
      let _ =
        result.map_error(
          handle_list_anime_command(ctx),
          handle_command_error_display,
        )
      Nil
    }
    "/search" <> search_term -> {
      let cleaned_search = string.trim(search_term)

      let _ =
        result.map_error(
          reply.with_text(ctx, "Yes let me search " <> cleaned_search),
          fn(_) { io.println_error("Could not execute command") },
        )
      Nil
    }
    _ -> {
      let _ =
        result.map_error(
          reply.with_text(ctx, "Unknown command: " <> command.text),
          fn(_) { io.println_error("Could not execute command") },
        )
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
