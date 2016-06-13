defmodule Mopidy.Playback do
  def current_track do
    data = %{method: "core.playback.get_current_track"}

    Mopidy.api_request(data)
  end

  def get_state do
    data = %{method: "core.playback.get_state"}

    Mopidy.api_request(data)
  end

  def get_stream_title do
    data = %{method: "core.playback.get_stream_title"}

    Mopidy.api_request(data)
  end

  def next do
    data = %{method: "core.playback.next"}

    Mopidy.api_request(data)
  end

  def pause do
    data = %{method: "core.playback.pause"}

    Mopidy.api_request(data)
  end

  def play do
    data = %{method: "core.playback.play"}

    Mopidy.api_request(data)
  end

  def previous do
    data = %{method: "core.playback.previous"}

    Mopidy.api_request(data)
  end

  def resume do
    data = %{method: "core.playback.resume"}

    Mopidy.api_request(data)
  end

  def set_state(state) do
    data = %{
      method: "core.playback.set_state",
      new_state: state
    }

    Mopidy.api_request(data)
  end

  def stop do
    data = %{method: "core.playback.stop"}

    Mopidy.api_request(data)
  end
end
