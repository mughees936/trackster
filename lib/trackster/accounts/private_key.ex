defmodule Trackster.Accounts.PrivateKey do
  use Trackster.Schema

  schema "private_keys" do
    field :is_active, :boolean
    field :renewal_at, :utc_datetime
    field :is_auto_renew, :boolean

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(private_key, attrs) do
    private_key
    |> cast(attrs, [:is_active, :renewal_at, :is_auto_renew])
  end

  def create_keys(count \\ 100) do
    Enum.map(1..count, fn _i ->
      %Trackster.Accounts.PrivateKey{}
      |> changeset(%{})
      |> Trackster.Repo.insert!()
    end)
  end
end
