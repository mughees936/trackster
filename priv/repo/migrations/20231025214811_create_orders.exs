defmodule Trackster.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  @table :orders

  def up do
    create table(@table, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :order_tracking_id, :string
      add :pickup_state, :string
      add :pickup_city, :string
      add :drop_state, :string
      add :drop_city, :string

      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false
      add :dispatch_courier_id, references(:couriers, on_delete: :delete_all, type: :binary_id), null: false
      add :recieving_courier_id, references(:couriers, on_delete: :delete_all, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end
  end

  def down do
    drop table(@table)
  end
end
