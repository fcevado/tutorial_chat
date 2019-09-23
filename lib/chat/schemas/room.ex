defmodule Chat.Schemas.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    has_many :messages, Chat.Schemas.Message
    field :name, :string

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
