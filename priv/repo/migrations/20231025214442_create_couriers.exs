defmodule Trackster.Repo.Migrations.CreateCouriers do
  use Ecto.Migration

  @table :couriers

  def up do
    create table(@table, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :phone, :string
      add :company, :string
      add :state, :string
      add :city, :string

      timestamps(type: :utc_datetime)
    end
  end

  def down do
    drop table(@table)
  end
end
