defmodule Trackster.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Trackster.Orders` context.
  """

  @doc """
  Generate a courier.
  """
  def courier_fixture(attrs \\ %{}) do
    {:ok, courier} =
      attrs
      |> Enum.into(%{
        city: "some city",
        company: "some company",
        name: "some name",
        phone: "some phone",
        state: "some state"
      })
      |> Trackster.Orders.create_courier()

    courier
  end

  @doc """
  Generate a address.
  """
  def address_fixture(attrs \\ %{}) do
    {:ok, address} =
      attrs
      |> Enum.into(%{
        city: "some city",
        state: "some state"
      })
      |> Trackster.Orders.create_address()

    address
  end

  @doc """
  Generate a tracking.
  """
  def tracking_fixture(attrs \\ %{}) do
    {:ok, tracking} =
      attrs
      |> Enum.into(%{
        description: "some description",
        order_id: 42,
        status: "some status"
      })
      |> Trackster.Orders.create_tracking()

    tracking
  end

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        order_tracking_id: "some order_tracking_id",
        user_id: 42
      })
      |> Trackster.Orders.create_order()

    order
  end
end
