defmodule Trackster.Repo.Migrations.AddEstimatedTime do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :estimated_delivery_after, :integer, null: false
    end
  end
end
