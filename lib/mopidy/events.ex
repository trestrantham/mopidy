defmodule Mopidy.Events do
  @moduledoc """
    Get a stream of Mopidy events
    """
  alias Mopidy.{TlTrack, Playlist}

  def create_stream do
    Stream.resource(
      fn -> Mopidy.Websocket.new end,
      fn (socket) ->
        Mopidy.Websocket.receive_next_event(socket)
      end,
      fn _ -> IO.puts("stream ended") end 
    )
  end

  # Entry point
  def parse_event(%{"event" => event} = body), do: {:ok, parse_event(event, body)}

  # Event parsing
  def parse_event(event, datum_data) when event in ~w(track_playback_resumed track_playback_paused track_playback_ended) do
    %{
      event: event,
      time_position: datum_data["time_position"],
      tl_track: Mopidy.parse_data(%TlTrack{}, datum_data["tl_track"], %{})
    }
  end

  def parse_event("track_playback_started" = event, datum_data)  do
    %{
      event: event,
      tl_track: Mopidy.parse_data(%TlTrack{}, datum_data["tl_track"], %{})
    }
  end  

  def parse_event("playlist_changed" = event, datum_data) do
    %{
      event: event,
      playlist: Mopidy.parse_data(%Playlist{}, datum_data["playlist"], %{})
    }
  end

  def parse_event(_, datum_data) do
    datum_data
  end  

end