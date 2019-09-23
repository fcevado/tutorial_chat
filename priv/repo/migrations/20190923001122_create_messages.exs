defmodule Chat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add(:user_id, references("users"))
      add(:room_id, references("rooms"))
      add(:content, :text, null: false)

      timestamps()
    end
  end
end
