defmodule Trackster.Repo.Migrations.AlterOrderTable do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :status, :string, default: "not_initiated"
    end
  end
end
