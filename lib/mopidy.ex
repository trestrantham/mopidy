defmodule Mopidy.Album do
  defstruct __model__: "Album", uri: nil, name: nil

  @type t :: %__MODULE__{
    __model__: binary,
    uri: binary,
    name: binary
  }
end

defmodule Mopidy.Artist do
  defstruct __model__: "Artist", uri: nil, name: nil

  @type t :: %__MODULE__{
    __model__: binary,
    uri: binary,
    name: binary
  }
end

defmodule Mopidy.Track do
  defstruct __model__: "Track", uri: nil, name: nil, album: nil, artists: []

  @type t :: %__MODULE__{
    __model__: binary,
    uri: binary,
    name: binary,
    album: %Mopidy.Album{},
    artists: List
  }
end

defmodule Mopidy.TlTrack do
  defstruct __model__: "TlTrack", tlid: nil, track: %Mopidy.Track{}

  @type t :: %__MODULE__{
    __model__: binary,
    tlid: integer,
    track: %Mopidy.Track{}
  }
end

defmodule Mopidy.Ref do
  defstruct __model__: "Ref", name: nil, type: nil, uri: nil

  @type t :: %__MODULE__{
    name: binary,
    __model__: binary,
    type: binary,
    uri: binary
  }
end

defmodule Mopidy.Image do
  defstruct __model__: "Image", uri: nil, width: nil, height: nil

  @type t :: %__MODULE__{
    __model__: binary,
    uri: binary,
    width: integer,
    height: integer
  }
end

defmodule Mopidy.SearchResult do
  defstruct __model__: "SearchResult", albums: [], artists: [], tracks: []

  @type t :: %__MODULE__{
    __model__: binary,
    albums: List,
    artists: List,
    tracks: List
  }
end

defmodule Mopidy.Playlist do
  defstruct __model__: "Playlist", name: nil, uri: nil

  @type t :: %__MODULE__{
    __model__: binary,
    name: binary,
    uri: binary
  }
end

defmodule Mopidy do
  @moduledoc """
  An HTTP client for Mopidy
  """

  alias Mopidy.{Album,Artist,Track,TlTrack,Ref,Image,SearchResult,Playlist}

  use Application
  use HTTPotion.Base

  @request_timeout 5_000

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

    with %HTTPotion.Response{body: body} <- Mopidy.post(nil, [body: body, timeout: mopidy_request_timeout]) do
      {:ok, body}
    else
      %HTTPotion.ErrorResponse{message: message} -> {:error, message}
      {:error, error} -> {:error, error}
      _ -> {:error, "could not process request"}
    end
  end

  def api_request(data, data_type) do
    with {:ok, body} <- Mopidy.api_request(data),
         {:ok, body} <- parse_data(data_type, body) do
        {:ok, body}
    else
      {:error, %{"error" => %{"data" => %{"message" => message}}}} ->
        {:error, message}
      {:error, %{"error" => %{"message" => message}}} ->
        {:error, message}
      {:error, message} ->
        {:error, message}
      _ ->
        {:error, "invalid response"}
    end
  end

  # Entry points
  def parse_data(_data_type, %{"error" => _error} = body), do: {:error, body}
  def parse_data(:success, _body), do: {:ok, :success}
  def parse_data(:value, body), do: {:ok, body["value"]}
  def parse_data(:result, body), do: {:ok, body["result"]}
  def parse_data(:uri, body), do: {:ok, parse_data(:uri, body["result"], %{})}
  def parse_data(data_type, body), do: {:ok, parse_data(data_type, body["result"], [])}

  # List parsing
  def parse_data(_data_type, nil, _accumulator), do: nil
  def parse_data(%Ref{} = data_type, [timestamp, %{"__model__" => "Ref"} = datum_data], _accumulator) when is_integer(timestamp) do
    %{
      timestamp: timestamp,
      ref: parse_data(data_type, datum_data, [])
    }
  end
  def parse_data(%SearchResult{} = data_type, [%{"__model__" => "SearchResult"} = datum_data], _accumulator) do
    parse_data(data_type, datum_data, [])
  end
  def parse_data(data_type, [head | tail], accumulator) when is_list(accumulator) do
    parse_data(data_type, tail, [parse_data(data_type, head, [])] ++ accumulator)
  end
  def parse_data(_data_type, [], accumulator), do: accumulator

  # Model parsing
  def parse_data(%TlTrack{}, %{"__model__" => "TlTrack"} = datum_data, _accumulator) do
    %TlTrack{
      tlid: datum_data["tlid"],
      track: parse_data(%Track{}, datum_data["track"], [])
    }
  end
  def parse_data(%Track{}, %{"__model__" => "Track"} = datum_data, _accumulator) do
    %Track{
      name: datum_data["name"],
      uri: datum_data["uri"],
      album: parse_data(%Album{}, datum_data["album"], []),
      artists: parse_data(%Artist{}, datum_data["artists"], [])
    }
  end
  def parse_data(%Artist{}, %{"__model__" => "Artist"} = datum_data, _accumulator) do
    %Artist{
      name: datum_data["name"],
      uri: datum_data["uri"]
    }
  end
  def parse_data(%Album{}, %{"__model__" => "Album"} = datum_data, _accumulator) do
    %Album{
      name: datum_data["name"],
      uri: datum_data["uri"]
    }
  end
  def parse_data(%Ref{}, %{"__model__" => "Ref"} = datum_data, _accumulator) do
    %Ref{
      name: datum_data["name"],
      type: datum_data["type"],
      uri: datum_data["uri"]
    }
  end
  def parse_data(%Image{}, %{"__model__" => "Image"} = datum_data, _accumulator) do
    %Image{
      uri: datum_data["uri"],
      width: datum_data["width"],
      height: datum_data["height"]
    }
  end
  def parse_data(%SearchResult{}, %{"__model__" => "SearchResult"} = datum_data, _accumulator) do
    %SearchResult{
      albums: parse_data(%Album{}, datum_data["albums"], []),
      artists: parse_data(%Artist{}, datum_data["artists"], []),
      tracks: parse_data(%Track{}, datum_data["tracks"], [])
    }
  end
  def parse_data(%Playlist{}, %{"__model__" => "Playlist"} = datum_data, _accumulator) do
    %Playlist{
      name: datum_data["name"],
      uri: datum_data["uri"]
    }
  end
  def parse_data(:uri, %{"__model__" => model_name} = datum_data, _accumulator) do
    model_struct = Module.concat(Mopidy, model_name).__struct__
    parse_data(model_struct, datum_data, [])
  end
  def parse_data(:uri = data_type, %{} = datum_data, _accumulator) do
    datum_data
    |> Map.keys
    |> Enum.map(fn(key) ->
      {key, parse_data(data_type, datum_data[key], [])}
    end)
    |> Enum.into(%{})
  end
  def parse_data(_, _, _), do: nil

  @doc """
  Gets the API URL from :mopidy, :api_url application env
  Returns binary
  """
  def mopidy_api_url do
    Application.get_env(:mopidy, :api_url)
  end

  def mopidy_request_timeout do
    Application.get_env(:mopidy, :request_timeout) || @request_timeout
  end
end
