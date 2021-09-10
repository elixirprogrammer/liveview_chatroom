defmodule MyChatWeb.RoomLive do
  use MyChatWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(message: "")
      |> assign(user_list: [])
      |> assign(messages: []), temporary_assigns: [messages: []]}
  end

  @impl true
  def handle_params(%{"room" => room, "username" => username}, _uri, socket) do
    topic = "room:" <> room

    if connected?(socket) do
      MyChatWeb.Endpoint.subscribe(topic)
      MyChatWeb.Presence.track(self(), topic, username, %{})
    end

    {:noreply,
      socket
      |> assign(username: username)
      |> assign(room: room)
      |> assign(topic: topic)}
  end

  @impl true
  def handle_event("submit-message", %{"chat" => %{"message" => message}}, socket) do
    {:ok, time} = System.system_time(:second) |> DateTime.from_unix

    message = %{
      uuid: UUID.uuid4(),
      content: message,
      username: socket.assigns.username,
      time: Time.to_string(time)
    }

    MyChatWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", message)

    {:noreply,
     socket
     |> assign(message: "")}
  end

  def handle_event("form-updated", %{"chat" => %{"message" => message}}, socket) do
    {:noreply,
     socket
     |> assign(message: message)}
  end

  @impl true
  def handle_info(%{event: "new-message", payload: message}, socket) do
    {:noreply,
     socket
     |> update(:messages, fn messages -> [message | messages] end)}
  end

  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    {:ok, time} = System.system_time(:second) |> DateTime.from_unix

    join_messages =
      joins
      |> Map.keys()
      |> Enum.map(fn username ->
        %{
          type: :system,
          uuid: UUID.uuid4(),
          content: "#{username} joined",
          time: Time.to_string(time)
        }
      end)

    leave_messages =
      leaves
      |> Map.keys()
      |> Enum.map(fn username ->
        %{
          type: :system,
          uuid: UUID.uuid4(),
          content: "#{username} left",
          time: Time.to_string(time)
        }
      end)

    user_list =
      MyChatWeb.Presence.list(socket.assigns.topic)
      |> Map.keys()

    {:noreply,
     socket
     |> update(:messages, fn _ -> join_messages ++ leave_messages end)
     |> assign(user_list: user_list)}
  end

  defp display_message(%{type: :system, uuid: uuid, content: content, time: time}) do
    ~E"""
    <div id="<%= uuid %>" class="p-4 bg-blue-100 rounded leading-8">
      <h5 class="font-semibold text-blue-500">
        Chat Bot
        <span class="float-right ml-auto text-gray-500"><%= time %></span>
      </h5>
      <p>
        <%= content %>
      </p>
    </div>
    """
  end

  defp display_message(%{uuid: uuid, content: content, username: username, time: time}) do
    ~E"""
    <div id="<%= uuid %>" class="p-4 bg-blue-100 rounded leading-8">
      <h5 class="font-semibold text-blue-500">
        <%= String.capitalize(username) %>
        <span class="float-right ml-auto text-gray-500"><%= time %></span>
      </h5>
      <p>
        <%= content %>
      </p>
    </div>
    """
  end
end
