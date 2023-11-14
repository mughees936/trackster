defmodule Trackster.Repo.Migrations.AddIsActiveTracking do
  use Ecto.Migration

  def change do
    alter table(:trackings) do
      add :is_active, :boolean, default: true
    end
  end
end
