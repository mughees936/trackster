defmodule Trackster.Orders.Order do
  use Trackster.Schema

  alias Trackster.Orders
  alias Trackster.Accounts.User
  alias Trackster.Orders.{Courier, Tracking, Address}

  @valid_order_status [
    "not_initiated",
    "creation",
    "pickup",
    "left_pickup_city",
    "left_pickup_state",
    "arrived_drop_state",
    "arrived_drop_city",
    "delivering",
    "signed"
  ]

  schema "orders" do
    field :order_tracking_id, :string
    field :estimated_delivery_after, :integer
    field :estimated_delivery_at, :utc_datetime, virtual: true
    field :status, :string

    belongs_to :user, User
    belongs_to :drop_address, Address
    belongs_to :pickup_address, Address
    belongs_to :dispatch_courier, Courier
    belongs_to :recieving_courier, Courier

    has_many :trackings, Tracking

    timestamps(type: :utc_datetime)
  end

  def get_valid_order_status, do: @valid_order_status |> List.delete("signed")

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [
      :estimated_delivery_at,
      :estimated_delivery_after,
      :order_tracking_id,
      :user_id,
      :dispatch_courier_id,
      :recieving_courier_id,
      :pickup_address_id,
      :drop_address_id,
      :status
    ])
    |> validate_attrs(order)
    |> validate_required([
      :estimated_delivery_after,
      :dispatch_courier_id,
      :recieving_courier_id,
      :order_tracking_id,
      :pickup_address_id,
      :drop_address_id,
      :user_id
    ])
  end

  def status_changeset(order, status) do
    order
    |> cast(%{"status" => status}, [:status])
    |> validate_required([:status])
  end

  defp validate_attrs(changeset, order) do
    changeset
    |> validate_put_couriers()
    |> validate_put_tracking_id(order.order_tracking_id)
    |> validate_put_estimated_delivery_after()
  end

  defp validate_put_tracking_id(changeset, order_tracking_id) do
    changeset
    |> put_change(:order_tracking_id, get_order_tracking_id(order_tracking_id))
  end

  defp validate_put_estimated_delivery_after(
         %{changes: %{estimated_delivery_at: delivery_time}} = changeset
       ) do
    IO.inspect(delivery_time, label: "Delivery")

    changeset
    |> put_change(:estimated_delivery_after, Timex.diff(delivery_time, Timex.now(), :minutes))
  end

  defp validate_put_estimated_delivery_after(changeset), do: changeset

  defp validate_put_couriers(
         %{changes: %{pickup_address_id: pickup_id, drop_address_id: drop_id}} = changeset
       ) do
    changeset
    |> put_change(:dispatch_courier_id, generate_random_courier(pickup_id))
    |> put_change(:recieving_courier_id, generate_random_courier(drop_id))
  end

  defp validate_put_couriers(%{changes: %{drop_address_id: drop_id}} = changeset) do
    changeset
    |> put_change(:recieving_courier_id, generate_random_courier(drop_id))
  end

  defp validate_put_couriers(%{changes: %{pickup_address_id: pickup_id}} = changeset) do
    changeset
    |> put_change(:dispatch_courier_id, generate_random_courier(pickup_id))
  end

  defp validate_put_couriers(changeset), do: changeset

  defp generate_random_courier(address_id) do
    courier =
      Orders.get_couriers_by_address(address_id)
      |> Enum.shuffle()
      |> hd

    courier.id
  end

  defp get_order_tracking_id(nil),
    do: "TKS-#{:crypto.strong_rand_bytes(16) |> Base.encode16()}"

  defp get_order_tracking_id(id), do: id
end
