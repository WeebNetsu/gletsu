import dot_env/env
import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/httpc
import gleam/result

pub fn get(
  endpoint: String,
) -> Result(response.Response(String), httpc.HttpError) {
  let assert Ok(base_req) =
    request.to(result.unwrap(env.get_string("API_URL"), "") <> endpoint)

  let base_req = request.set_method(base_req, http.Get)

  let req =
    request.prepend_header(base_req, "accept", "application/vnd.api+json")

  // Send the HTTP request to the server
  use resp <- result.try(httpc.send(req))

  // We get a response record back
  //   assert resp.status == 200

  let content_type = response.get_header(resp, "content-type")
  assert content_type == Ok("application/vnd.api+json")

  Ok(resp)
}
