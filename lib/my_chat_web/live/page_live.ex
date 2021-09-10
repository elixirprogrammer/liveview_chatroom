defmodule MyChatWeb.PageLive do
  use MyChatWeb, :live_view

  @chat_rooms [
    Elixir: "elixir",
    Phoenix: "phoenix",
    LiveView: "liveView",
    Tailwind: "tailwind",
    Alpine: "alpine"
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(chat_rooms: @chat_rooms)}
  end

  @impl true
  def handle_event("join_chat", %{"join_chat" => params}, socket) do
    {:noreply,
     socket
     |> push_redirect(
       to: Routes.room_path(socket, :index, params["chat_room"], username: params["username"])
     )}
  end
end
