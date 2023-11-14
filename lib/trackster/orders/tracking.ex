defmodule Trackster.Orders.Tracking do
  use Trackster.Schema
  alias Trackster.Orders.Order

  schema "trackings" do
    field :status, :string
    field :description, :string
    field :is_active, :boolean

    belongs_to :order, Order

    timestamps(type: :utc_datetime, updated_at: false)
  end

  @doc false
  def changeset(attrs) do
    %Trackster.Orders.Tracking{}
    |> cast(attrs, [:status, :description, :order_id, :is_active])
    |> validate_required([:status, :description, :order_id])
  end

  @doc false
  def update_changeset(tracking, attrs) do
    tracking
    |> cast(attrs, [:is_active])
    |> validate_required([:is_active])
  end
end
