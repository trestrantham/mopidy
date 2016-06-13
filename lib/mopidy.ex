defmodule Mopidy do
  @moduledoc """
  An HTTP client for Mopidy
  """

  use Application
  use HTTPotion.Base

  def start(_type, _args) do
    start
    Mopidy.Supervisor.start_link
  end

  @doc """
  Creates the URL for our endpoint.
  Args:
    * endpoint - part of the API we're hitting
  Returns string
  """
  def process_url(endpoint) do
    mopidy_api_url <> endpoint
  end

  def process_request_body(body) do
    Poison.encode! body
  end

  def process_response_body(body) do
    Poison.decode! body
  end

  @doc """
  Set our request headers for every request.
  """
  def process_request_headers(headers) do
    Dict.put headers, :"User-Agent", "Mopidy/v1 mopidy-elixir/0.0.1"
    Dict.put headers, :"Content-Type", "application/json"
  end

  @doc """
  Boilerplate code to make requests.
  Args:
    * method - atom HTTP method
    * endpoint - string requested API endpoint
    * body - request body
  Returns dict
  """
  def api_request(data \\ %{}) do
    Mopidy.post nil,
    [
      body: Map.merge(
        %{
          id: "1",
          jsonrpc: "2.0"
        },
        data
      )
    ]

    # case request(method, endpoint, body) do
    #   {:ok, response} ->
    #     (case response.body do
    #       %{"errors" => errors} ->
    #         error = List.first(errors)
    #         {:error, %{error: error["errorType"], message: error["message"]}}
    #       _ ->
    #         {:ok, response.body}
    #     end)
    #   {:error, reason} ->
    #     {:error, %{error: "bad_request", message: reason}}
    # end
  end

  @doc """
  Gets the API URL from :mopidy, :api_url application env or ENV
  Returns binary
  """
  def mopidy_api_url do
    Application.get_env(:mopidy, :api_url) ||
      System.get_env("MOPIDY_API_URL")
  end
end
