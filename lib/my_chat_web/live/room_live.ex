defmodule MyChatWeb.RoomLive do
  use MyChatWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"room" => room, "username" => username}, _uri, socket) do
    {:noreply,
      socket
      |> assign(username: username)
      |> assign(room: room)}
  end
end
