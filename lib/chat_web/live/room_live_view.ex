defmodule ChatWeb.RoomLiveView do
  use Phoenix.LiveView

  def render(assigns) do
    ChatWeb.RoomView.render("show.html", assigns)
  end

  def mount(%{room: room, user: user}, socket) do
    ChatWeb.Endpoint.subscribe(topic(room.name))
    ChatWeb.RoomUsers.track(self(), topic(room.name), user.id, build_meta(user))
    users = fetch_users(room.name)

    {:ok, assign(socket, room: room, message: Chat.new_message(), user: user, users: users)}
  end

  def handle_event("message", %{"message" => msg_params}, socket) do
    msg = Chat.insert_message(msg_params)
    room = Chat.get_room(msg.id)

    ChatWeb.Endpoint.broadcast_from(self(), topic(room.name), "message", %{room: room})

    {:noreply, assign(socket, room: room, message: Chat.new_message())}
  end

  def handle_event("typing", _, socket = %{assings: %{room: room, user: user}}) do
    room.name
    |> topic()
    |> track_typing(user.id, true)

    {:noreply, socket}
  end

  def handle_event("stop_typing", _, socket = %{assings: %{room: room, user: user}}) do
    room.name
    |> topic()
    |> track_typing(user.id, false)

    {:noreply, socket}
  end

  def handle_info(%{event: "message", payload: assign}, socket) do
    {:noreply, assign(socket, assign)}
  end

  def handle_info(%{event: "presence_diff"}, socket = %{assigns: %{room: room}}) do
    users = fetch_users(room.name)

    {:noreply, assign(socket, users: users)}
  end

  defp topic(name) do
    "room:#{name}"
  end

  defp fetch_users(name) do
    name
    |> topic()
    |> ChatWeb.RoomUsers.list()
    |> Enum.map(fn {_id, p} -> List.first(p[:metas]) end)
  end

  defp track_typing(topic, key, typing) do
    meta =
      topic
      |> ChatWeb.RoomUsers.get_by_key(key)
      |> Map.get(:metas)
      |> List.first()

    Presence.update(self(), topic, key, build_meta(meta, typing))
  end

  defp build_meta(meta_user, typing \\ false) do
    %{
      email: meta_user.email,
      id: meta_user.email,
      typing: typing
    }
  end
end
