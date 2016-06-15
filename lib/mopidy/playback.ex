defmodule Mopidy.Playback do
  alias Mopidy.{TlTrack,Track}

  def get_current_tl_track do
    data = %{method: "core.playback.get_current_tl_track"}

    Mopidy.api_request(data, %TlTrack{})
  end

  def get_current_tlid do
    data = %{method: "core.playback.get_current_tlid"}

    Mopidy.api_request(data, :result)
  end

  def get_current_track do
    data = %{method: "core.playback.get_current_track"}

    Mopidy.api_request(data, %Track{})
  end

  def get_state do
    data = %{method: "core.playback.get_state"}

    Mopidy.api_request(data, :result)
  end

  def get_stream_title do
    data = %{method: "core.playback.get_stream_title"}

    Mopidy.api_request(data, :result)
  end

  def get_time_position do
    data = %{method: "core.playback.get_time_position"}

    Mopidy.api_request(data, :result)
  end

  def next do
    data = %{method: "core.playback.next"}

    Mopidy.api_request(data, :success)
  end

  def pause do
    data = %{method: "core.playback.pause"}

    Mopidy.api_request(data, :success)
  end

  def play(tlid \\ nil) do
    data = %{
      method: "core.playback.play",
      tlid: tlid
    }

    Mopidy.api_request(data, :success)
  end

  def previous do
    data = %{method: "core.playback.previous"}

    Mopidy.api_request(data, :success)
  end

  def resume do
    data = %{method: "core.playback.resume"}

    Mopidy.api_request(data, :success)
  end

  def seek(time_position) do
    data = %{
      method: "core.playback.seek",
      params: %{
        time_position: time_position
      }
    }

    Mopidy.api_request(data, :result)
  end

  def set_state(state) do
    data = %{
      method: "core.playback.set_state",
      params: %{
        new_state: state
      }
    }

    Mopidy.api_request(data, :success)
  end

  def stop do
    data = %{method: "core.playback.stop"}

    Mopidy.api_request(data, :success)
  end
end
