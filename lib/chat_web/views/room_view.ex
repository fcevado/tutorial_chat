defmodule ChatWeb.RoomView do
  use ChatWeb, :view

  def name(email) do
    email
    |> String.split("@")
    |> List.first()
  end
end
