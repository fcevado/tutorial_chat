defmodule ChatWeb.RoomController do
  use ChatWeb, :controller
  alias ChatWeb.RoomLiveView

  def show(conn, %{"id" => id}) do
    room = Chat.get_room(id)

    live_render(conn, RoomLiveView, session: %{room: room, user: conn.assigns.current_user})
  end
end
