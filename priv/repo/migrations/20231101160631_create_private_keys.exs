defmodule Trackster.Repo.Migrations.CreatePrivateKeys do
  use Ecto.Migration

  def change do
    create table(:private_keys, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :is_active, :boolean, default: false
      add :renewal_at, :utc_datetime
      add :is_auto_renew, :boolean, default: true

      timestamps(type: :utc_datetime)
    end

    alter table(:users) do
      add :private_key_id, references(:private_keys, on_delete: :delete_all, type: :binary_id), null: false
      add :full_name, :string
    end

    create unique_index(:users, [:private_key_id])
  end
end
