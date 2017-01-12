defmodule Mopidy.Events do`
  @moduledoc """
    Get a stream of Mopidy events
    """
  def create_stream do
    Stream.resource(
      fn -> Mopidy.Websocket.new end,
      fn (socket) ->
        Mopidy.Websocket.receive_next_event(socket)
      end,
      fn _ -> IO.puts("stream ended") end 
    )
  end
end