defmodule Trackster.Orders.Courier do
  use Trackster.Schema

  schema "couriers" do
    field :name, :string
    field :phone, :string
    field :company, :string

    belongs_to :address, Trackster.Orders.Address

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(courier, attrs) do
    courier
    |> cast(attrs, [:name, :phone, :address_id])
    |> validate_required([:name, :phone, :address_id])
  end
end
