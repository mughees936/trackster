defmodule Trackster.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Trackster.Repo

  alias Trackster.Orders.{Courier, Order, Tracking, Address}

  @doc """
  Returns the list of couriers.

  ## Examples

      iex> list_couriers()
      [%Courier{}, ...]

  """
  def list_couriers do
    Repo.all(Courier)
  end

  @doc """
  Gets a single courier.

  Raises `Ecto.NoResultsError` if the Courier does not exist.

  ## Examples

      iex> get_courier!(123)
      %Courier{}

      iex> get_courier!(456)
      ** (Ecto.NoResultsError)

  """
  def get_courier!(id), do: Repo.get!(Courier, id)

  @doc """
  Creates a courier.

  ## Examples

      iex> create_courier(%{field: value})
      {:ok, %Courier{}}

      iex> create_courier(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_courier(attrs \\ %{}) do
    %Courier{}
    |> Courier.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a courier.

  ## Examples

      iex> update_courier(courier, %{field: new_value})
      {:ok, %Courier{}}

      iex> update_courier(courier, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_courier(%Courier{} = courier, attrs) do
    courier
    |> Courier.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a courier.

  ## Examples

      iex> delete_courier(courier)
      {:ok, %Courier{}}

      iex> delete_courier(courier)
      {:error, %Ecto.Changeset{}}

  """
  def delete_courier(%Courier{} = courier) do
    Repo.delete(courier)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking courier changes.

  ## Examples

      iex> change_courier(courier)
      %Ecto.Changeset{data: %Courier{}}

  """
  def change_courier(%Courier{} = courier, attrs \\ %{}) do
    Courier.changeset(courier, attrs)
  end

  def get_couriers_by_address(nil), do: []

  def get_couriers_by_address(address_id) do
    from(c in Courier,
      where: c.address_id == ^address_id
    )
    |> Repo.all()
  end

  @doc """
  Returns the list of addresses.

  ## Examples

      iex> list_addresses()
      [%Address{}, ...]

  """
  def list_addresses do
    Repo.all(Address)
  end

  @doc """
  Gets a single address.

  Raises `Ecto.NoResultsError` if the Address does not exist.

  ## Examples

      iex> get_address!(123)
      %Address{}

      iex> get_address!(456)
      ** (Ecto.NoResultsError)

  """
  def get_address!(id), do: Repo.get!(Address, id)

  @doc """
  Creates a address.

  ## Examples

      iex> create_address(%{field: value})
      {:ok, %Address{}}

      iex> create_address(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_address(attrs \\ %{}) do
    %Address{}
    |> Address.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a address.

  ## Examples

      iex> update_address(address, %{field: new_value})
      {:ok, %Address{}}

      iex> update_address(address, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_address(%Address{} = address, attrs) do
    address
    |> Address.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a address.

  ## Examples

      iex> delete_address(address)
      {:ok, %Address{}}

      iex> delete_address(address)
      {:error, %Ecto.Changeset{}}

  """
  def delete_address(%Address{} = address) do
    Repo.delete(address)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking address changes.

  ## Examples

      iex> change_address(address)
      %Ecto.Changeset{data: %Address{}}

  """
  def change_address(%Address{} = address, attrs \\ %{}) do
    Address.changeset(address, attrs)
  end

  @doc """
  Returns the list of trackings.

  ## Examples

      iex> list_trackings()
      [%Tracking{}, ...]

  """
  def list_trackings do
    Repo.all(Tracking)
  end

  @doc """
  Gets a single tracking.

  Raises `Ecto.NoResultsError` if the Tracking does not exist.

  ## Examples

      iex> get_tracking!(123)
      %Tracking{}

      iex> get_tracking!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tracking!(id), do: Repo.get!(Tracking, id)

  @doc """
  Deletes a tracking.

  ## Examples

      iex> delete_tracking(tracking)
      {:ok, %Tracking{}}

      iex> delete_tracking(tracking)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tracking(%Tracking{} = tracking) do
    Repo.delete(tracking)
  end

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order) |> order_preloads()
  end

  def get_past_due_in_status(status, timestamp) do
    from(o in Order,
      join: t in Tracking,
      on: o.id == t.order_id,
      where:
        o.status == ^status and
          t.inserted_at < ^timestamp and
          t.status == ^status,
      select: o
    )
    |> Repo.all()
    |> order_preloads()
  end

  # def get_past_due_in_initiation(delay),
  #   do: orders_with_elapsed_status_change(["not_initiated"], delay)

  # def get_past_due_in_creation(delay), do: orders_with_elapsed_status_change(["creation"], delay)

  # def get_past_due_in_pickup(delay), do: orders_with_elapsed_status_change(["pickup"], delay)

  # def get_past_due_in_transit() do
  #   from(o in Order,
  #     where:
  #       o.status == "in_transit" and
  #         o.estimated_delivery_after < ^DateTime.utc_now()
  #   )
  #   |> IO.inspect(label: "query")
  #   |> Repo.all()
  #   |> order_preloads()
  #   |> IO.inspect(label: "data")
  # end

  # def get_past_due_in_delivering(delay),
  #   do: orders_with_elapsed_status_change(["delivering"], delay)

  # def orders_with_elapsed_status_change(status, delay) when is_integer(delay) do
  #   timestamp =
  #     Timex.now()
  #     |> Timex.shift(seconds: -delay)

  #   from(o in Order,
  #     where: o.status in ^status and o.inserted_at < ^timestamp
  #   )
  #   |> Repo.all()
  #   |> order_preloads()
  # end

  def list_user_orders(user_id) do
    from(c in Order,
      where: c.user_id == ^user_id
    )
    |> Repo.all()
    |> order_preloads()
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id) |> order_preloads()

  def maybe_get_order_by_tracking(order_tracking_id) do
    from(
      p in Order,
      where: p.order_tracking_id == ^order_tracking_id,
      select: p,
      preload: [
        trackings:
          ^from(
            a in Tracking,
            order_by: [desc: a.inserted_at]
          )
      ]
    )
    |> Repo.one()
  end

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:order, Order.changeset(%Order{}, attrs))
    |> Multi.insert(:tracking, fn %{order: order} ->
      Tracking.changeset(%{
        "description" => "none",
        "status" => "not_initiated",
        "order_id" => order.id
      })
    end)
    |> Repo.transaction()
    |> IO.inspect(label: "orders updated")
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  def order_preloads(orders) do
    orders
    |> Repo.preload(:pickup_address)
    |> Repo.preload(:drop_address)
    |> Repo.preload(:dispatch_courier)
    |> Repo.preload(:recieving_courier)
    |> Repo.preload(:trackings)
  end
end
