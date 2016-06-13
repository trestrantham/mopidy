defmodule Mopidy.History do
  def get_history do
    data = %{method: "core.history.get_history"}

    Mopidy.api_request(data)
  end

  def get_length do
    data = %{method: "core.history.get_length"}

    Mopidy.api_request(data)
  end
end
