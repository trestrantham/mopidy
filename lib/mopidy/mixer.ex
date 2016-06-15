defmodule Mopidy.Mixer do
  def get_mute do
    data = %{method: "core.mixer.get_mute"}

    Mopidy.api_request(data, :result)
  end

  def get_volume do
    data = %{method: "core.mixer.get_volume"}

    Mopidy.api_request(data, :result)
  end

  def set_mute(value) do
    data = %{
      method: "core.mixer.set_mute",
      params: %{
        mute: value
      }
    }

    Mopidy.api_request(data, :result)
  end

  def set_volume(value) do
    data = %{
      method: "core.mixer.set_volume",
      params: %{
        volume: value
      }
    }

    Mopidy.api_request(data, :result)
  end
end
