defmodule Chat do
  @moduledoc """
  Chat keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Chat.Schemas.{Room, Message}
  alias Chat.Repo
  alias Ecto.Changeset

  def insert_room(params) do
    %Room{}
    |> Room.changeset(params)
    |> Repo.insert!()
  end

  def get_room(id) do
    Room
    |> Repo.get(id)
    |> Repo.preload(messages: [:user])
  end

  def new_message do
    %Message{}
    |> Changeset.cast(%{}, [])
  end

  def insert_message(params) do
    %Message{}
    |> Message.changeset(params)
    |> Repo.insert!()
  end
end
