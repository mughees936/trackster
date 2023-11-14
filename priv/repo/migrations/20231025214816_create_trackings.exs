defmodule Trackster.Repo.Migrations.CreateTrackings do
  use Ecto.Migration

  @table :trackings

  def up do
    create table(@table, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :status, :string
      add :description, :string
      add :order_id, references(:orders, on_delete: :delete_all, type: :binary_id), null: false

      timestamps(type: :utc_datetime, updated_at: false)
    end
  end

  def down do
    drop table(@table)
  end
end
