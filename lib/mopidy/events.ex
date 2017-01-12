defmodule Mopidy.Events do

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