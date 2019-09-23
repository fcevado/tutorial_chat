defmodule Chat.Schemas.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    belongs_to :user, Chat.Users.User
    belongs_to :room, Chat.Schemas.Room
    field :content, :string

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:user_id, :room_id, :content])
    |> validate_required([:user_id, :room_id, :content])
  end
end
