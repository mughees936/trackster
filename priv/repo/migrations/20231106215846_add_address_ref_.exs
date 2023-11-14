defmodule Trackster.Repo.Migrations.AddAddressRef do
  use Ecto.Migration

  def change do
    alter table(:couriers) do
      remove :state, :string
      remove :city, :string

      add :address_id, references(:addresses, on_delete: :delete_all, type: :binary_id), null: false
    end

    alter table(:orders) do
      remove :pickup_state, :string
      remove :pickup_city, :string
      remove :drop_state, :string
      remove :drop_city, :string

      add :pickup_address_id, references(:addresses, on_delete: :delete_all, type: :binary_id), null: false
      add :drop_address_id, references(:addresses, on_delete: :delete_all, type: :binary_id), null: false
    end

  end
end
