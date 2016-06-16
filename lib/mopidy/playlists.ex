defmodule Mopidy.Playlists do
  alias Mopidy.{Ref,Playlist}

  def as_list do
    data = %{method: "core.playlists.as_list"}

    Mopidy.api_request(data, %Ref{})
  end

  def create(name, uri_scheme \\ nil) do
    data = %{
      method: "core.playlists.create",
      params: %{
        name: name,
        uri_scheme: uri_scheme
      }
    }

    Mopidy.api_request(data, %Playlist{})
  end

  def delete(uri) do
    data = %{
      method: "core.playlists.delete",
      params: %{
        uri: uri
      }
    }

    Mopidy.api_request(data, :success)
  end

  def filter(criteria \\ %{}) do
    data = %{
      method: "core.playlists.filter",
      params: %{
        criteria: criteria
      }
    }

    Mopidy.api_request(data, %Playlist{})
  end

  def get_items(uri \\ nil) do
    data = %{
      method: "core.playlists.get_items",
      params: %{
        uri: uri
      }
    }

    Mopidy.api_request(data, %Ref{})
  end

  def get_playlists(include_tracks \\ false) do
    data = %{
      method: "core.playlists.get_playlists",
      params: %{
        include_tracks: include_tracks
      }
    }

    Mopidy.api_request(data, %Playlist{})
  end

  def get_uri_schemes do
    data = %{method: "core.playlists.get_uri_schemes"}

    Mopidy.api_request(data, :result)
  end

  def lookup(uri \\ nil) do
    data = %{
      method: "core.playlists.lookup",
      params: %{
        uri: uri
      }
    }

    Mopidy.api_request(data, %Playlist{})
  end

  def refresh(uri_scheme \\ nil) do
    data = %{
      method: "core.playlists.refresh",
      params: %{
        uri_scheme: uri_scheme
      }
    }

    Mopidy.api_request(data, :success)
  end

  @doc """
  Saves the given `%Mopidy.Playlist{}`

  Returns `:ok` and the saved `%Mopidy.Playlist{}` or `nil`

  ## Examples

    iex> Mopidy.Playlists.save(playlist)
    {:ok, %Mopidy.Playlist{}}

  """
  def save(%Playlist{} = playlist) do
    data = %{
      method: "core.playlists.save",
      params: %{
        playlist: playlist
      }
    }

    Mopidy.api_request(data, %Playlist{})
  end
end
