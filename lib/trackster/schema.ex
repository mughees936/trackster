defmodule Trackster.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @timestamps_opts [type: :utc_datetime]
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id

      import Ecto.Changeset
      import Ecto.Query
    end
  end
end
