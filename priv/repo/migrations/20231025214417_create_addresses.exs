defmodule Trackster.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  @table :addresses

  def up do
    create table(@table, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :state, :string
      add :city, :string

      timestamps(type: :utc_datetime)
    end
  end

  def down do
    drop table(@table)
  end
end
