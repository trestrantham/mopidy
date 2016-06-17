defmodule Mopidy.Library do
  alias Mopidy.{Ref,SearchResult}

  def browse(uri \\ nil) do
    data = %{
      method: "core.library.browse",
      params: %{
        uri: uri
      }
    }

    Mopidy.api_request(data, %Ref{})
  end

  def get_distinct(field, query) do
    data = %{
      method: "core.library.get_distinct",
      params: %{
        field: field,
        query: query
      }
    }

    Mopidy.api_request(data, :result)
  end

  def get_images(uris) do
    data = %{
      method: "core.library.get_images",
      params: %{
        uris: uris
      }
    }

    Mopidy.api_request(data, :uri)
  end

  def lookup(uris \\ nil) do
    data = %{
      method: "core.library.lookup",
      params: %{
        uris: uris
      }
    }

    Mopidy.api_request(data, :uri)
  end

  def refresh(uri \\ nil) do
    data = %{
      method: "core.library.refresh",
      params: %{
        uri: uri
      }
    }

    Mopidy.api_request(data, :success)
  end

  def search(query), do: search(query, nil)
  def search(query, uris, exact \\ true) do
    data = %{
      method: "core.library.search",
      params: %{
        query: query,
        uris: uris,
        exact: exact
      }
    }

    Mopidy.api_request(data, %SearchResult{})
  end
end
