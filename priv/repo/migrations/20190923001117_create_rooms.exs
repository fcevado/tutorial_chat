defmodule Chat.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add(:name, :text, null: false)

      timestamps()
    end

    create(unique_index(:rooms, [:name]))
  end
end
