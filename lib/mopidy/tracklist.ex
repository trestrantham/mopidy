defmodule Mopidy.Tracklist do
  alias Mopidy.{TlTrack,Track}

  def add(uris \\ nil) do
    data = %{
      method: "core.tracklist.add",
      params: %{
        uris: uris
      }
    }

    Mopidy.api_request(data, %TlTrack{})
  end

  def clear do
    data = %{method: "core.tracklist.clear"}

    Mopidy.api_request(data, :success)
  end

  def eot_track do
    data = %{
      method: "core.tracklist.eot_track",
      params: %{
        tl_track: nil
      }
    }

    Mopidy.api_request(data, %TlTrack{})
  end

  def filter(criteria \\ %{}) do
    data = %{
      method: "core.tracklist.filter",
      params: %{
        criteria: criteria
      }
    }

    Mopidy.api_request(data, %TlTrack{})
  end

  def get_consume do
    data = %{method: "core.tracklist.get_consume"}

    Mopidy.api_request(data, :result)
  end

  def get_eot_tlid do
    data = %{method: "core.tracklist.get_eot_tlid"}

    Mopidy.api_request(data, :result)
  end

  def get_length do
    data = %{method: "core.tracklist.get_length"}

    Mopidy.api_request(data, :result)
  end

  def get_next_tlid do
    data = %{method: "core.tracklist.get_next_tlid"}

    Mopidy.api_request(data, :result)
  end

  def get_previous_tlid do
    data = %{method: "core.tracklist.get_previous_tlid"}

    Mopidy.api_request(data, :result)
  end

  def get_random do
    data = %{method: "core.tracklist.get_random"}

    Mopidy.api_request(data, :result)
  end

  def get_repeat do
    data = %{method: "core.tracklist.get_repeat"}

    Mopidy.api_request(data, :result)
  end

  def get_single do
    data = %{method: "core.tracklist.get_single"}

    Mopidy.api_request(data, :result)
  end

  def get_tl_tracks do
    data = %{method: "core.tracklist.get_tl_tracks"}

    Mopidy.api_request(data, %TlTrack{})
  end

  def get_tracks do
    data = %{method: "core.tracklist.get_tracks"}

    Mopidy.api_request(data, %Track{})
  end

  def get_version do
    data = %{method: "core.tracklist.get_version"}

    Mopidy.api_request(data, :result)
  end

  def index(tlid) do
    data = %{
      method: "core.tracklist.index",
      params: %{
        tlid: tlid
      }
    }

    Mopidy.api_request(data, :result)
  end

  def move(start_position, end_position, to_position) do
    data = %{
      method: "core.tracklist.move",
      params: %{
        start: start_position,
        end: end_position,
        to_position: to_position
      }
    }

    Mopidy.api_request(data, :success)
  end

  def next_track(tl_track \\ %TlTrack{}) do
    data = %{
      method: "core.tracklist.next_track",
      params: %{
        tl_track: tl_track.tlid
      }
    }

    Mopidy.api_request(data, %TlTrack{})
  end

  def previous_track(tl_track \\ %TlTrack{}) do
    data = %{
      method: "core.tracklist.previous_track",
      params: %{
        tl_track: tl_track.tlid
      }
    }

    Mopidy.api_request(data, %TlTrack{})
  end

  def remove(criteria \\ %{}) do
    data = %{
      method: "core.tracklist.remove",
      params: %{
        criteria: criteria
      }
    }

    Mopidy.api_request(data, %TlTrack{})
  end

  def set_consume(value) do
    data = %{
      method: "core.tracklist.set_consume",
      params: %{
        value: value
      }
    }

    Mopidy.api_request(data, :success)
  end

  def set_random(value) do
    data = %{
      method: "core.tracklist.set_random",
      params: %{
        value: value
      }
    }

    Mopidy.api_request(data, :success)
  end

  def set_repeat(value) do
    data = %{
      method: "core.tracklist.set_repeat",
      params: %{
        value: value
      }
    }

    Mopidy.api_request(data, :success)
  end

  def set_single(value) do
    data = %{
      method: "core.tracklist.set_single",
      params: %{
        value: value
      }
    }

    Mopidy.api_request(data, :success)
  end

  def shuffle do
    data = %{method: "core.tracklist.shuffle"}

    Mopidy.api_request(data, :success)
  end

  def slice(start_position, end_position) do
    data = %{
      method: "core.tracklist.slice",
      params: %{
        start: start_position,
        end: end_position
      }
    }

    Mopidy.api_request(data, %TlTrack{})
  end
end
