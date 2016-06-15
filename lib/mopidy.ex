defmodule Mopidy.Album do
  defstruct uri: nil, name: nil

  @type t :: %__MODULE__{
    uri: binary,
    name: binary
  }
end

defmodule Mopidy.Artist do
  defstruct uri: nil, name: nil

  @type t :: %__MODULE__{
    uri: binary,
    name: binary
  }
end

defmodule Mopidy.Track do
  defstruct uri: nil, name: nil, album: nil, artists: []

  @type t :: %__MODULE__{
    uri: binary,
    name: binary,
    album: %Mopidy.Album{},
    artists: List
  }
end

defmodule Mopidy.TlTrack do
  defstruct tlid: nil, track: %Mopidy.Track{}

  @type t :: %__MODULE__{
    tlid: integer,
    track: %Mopidy.Track{}
  }
end

defmodule Mopidy.Ref do
  defstruct name: nil, type: nil, uri: nil

  @type t :: %__MODULE__{
    name: binary,
    type: binary,
    uri: binary
  }
end

defmodule Mopidy do
  @moduledoc """
  An HTTP client for Mopidy
  """

  alias Mopidy.{Album,Artist,Track,TlTrack,Ref}

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
    body = Map.merge(%{id: "1", jsonrpc: "2.0"}, data)

    with %HTTPotion.Response{body: body} <- Mopidy.post(nil, [body: body]) do
      {:ok, body}
    else
      %HTTPotion.ErrorResponse{message: message} -> {:error, message}
      {:error, error} -> {:error, error}
      _ -> {:error, "could not process request"}
    end
  end

  def api_request(data, data_type) do
    case Mopidy.api_request(data) do
      {:ok, %{"error" => error} = body} ->
        error_response(body)
      {:ok, body} ->
        case data_type do
          %Mopidy.TlTrack{} ->
            {:ok, parse_tl_tracks(body["result"], [])}
          %Mopidy.Track{} ->
            {:ok, parse_tracks(body["result"], [])}
          :result ->
            {:ok, body["result"]}
          :success ->
            {:ok, :success}
          _ ->
            {:ok, body["value"]}
        end
      error ->
        error_response(error)
    end
  end

  def error_response(%{"error" => %{"data" => %{"message" => message}}}) do
    {:error, message}
  end
  def error_response(%{"error" => %{"message" => message}}) do
    {:error, message}
  end
  def error_response({:error, message}), do: {:error, message}
  def error_response(message) when is_binary(message) do
    {:error, message}
  end
  def error_response(_) do
    {:error, "invalid response"}
  end

  # TlTrack parsing
  def parse_tl_tracks(nil, _accumulator), do: nil
  def parse_tl_tracks([tl_track | tl_tracks], accumulator) when is_list(accumulator) do
    parse_tl_tracks(tl_tracks, [parse_tl_track(tl_track)] ++ accumulator)
  end
  def parse_tl_tracks(%{"__model__" => "TlTrack"} = tl_track_data, _accumulator) do
    parse_tl_track(tl_track_data)
  end
  def parse_tl_tracks([], accumulator), do: accumulator

  def parse_tl_track(%{"__model__" => "TlTrack"} = tl_track_data) do
    %Mopidy.TlTrack{
      tlid: tl_track_data["tlid"],
      track: parse_track(tl_track_data["track"])
    }
  end
  def parse_tl_track(_), do: nil

  # Track parsing
  def parse_tracks(nil, _accumulator), do: nil
  def parse_tracks([track | tracks], accumulator) when is_list(accumulator) do
    parse_tracks(tracks, [parse_track(track)] ++ accumulator)
  end
  def parse_tracks(%{"__model__" => "Track"} = track_data, _accumulator) do
    parse_track(track_data)
  end
  def parse_tracks([], accumulator), do: accumulator

  def parse_track(%{"__model__" => "Track"} = track_data) do
    %Mopidy.Track{
      name: track_data["name"],
      uri: track_data["uri"],
      album: parse_album(track_data["album"]),
      artists: parse_artists(track_data["artists"], [])
    }
  end
  def parse_track(_), do: nil

  # Artist parsing
  def parse_artists([artist | artists], accumulator) when is_list(accumulator) do
    parse_artists(artists, [parse_artist(artist)] ++ accumulator)
  end
  def parse_artists([], accumulator), do: accumulator

  def parse_artist(%{"__model__" => "Artist"} = artist_data) do
    %Mopidy.Artist{
      name: artist_data["name"],
      uri: artist_data["uri"]
    }
  end

  # Album parsing
  def parse_album(%{"__model__" => "Album"} = album_data) do
    %Mopidy.Album{
      name: album_data["name"],
      uri: album_data["uri"]
    }
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
