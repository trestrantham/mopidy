defmodule Mopidy.Core do
  def get_uri_schemes do
    data = %{method: "core.get_uri_schemes"}

    Mopidy.api_request(data, :result)
  end

  def get_version do
    data = %{method: "core.get_version"}

    Mopidy.api_request(data, :result)
  end
end
