defmodule Mopidy.Library do
  def browse(uris \\ nil) do
    data = %{
      method: "core.library.browse",
      params: %{
        uris: uris
      }
    }

    Mopidy.api_request(data)
  end

  def get_distinct(field, query \\ nil) do
    data = %{
      method: "core.library.get_distinct",
      params: %{
        field: field,
        query: query
      }
    }

    Mopidy.api_request(data)
  end

  def get_images(uris \\ nil) do
    data = %{
      method: "core.library.get_images",
      params: %{
        uris: uris
      }
    }

    Mopidy.api_request(data)
  end

  def lookup(uris \\ nil) do
    data = %{
      method: "core.library.lookup",
      params: %{
        uris: uris
      }
    }

    Mopidy.api_request(data)
  end

  def refresh(uris \\ nil) do
    data = %{
      method: "core.library.refresh",
      params: %{
        uris: uris
      }
    }

    Mopidy.api_request(data)
  end

  def search(query, uris \\ nil) do
    data = %{
      method: "core.library.search",
      params: %{
        query: query,
        uris: uris,
        exact: false
      }
    }

    Mopidy.api_request(data)
  end
end
