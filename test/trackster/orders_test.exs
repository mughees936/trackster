defmodule Trackster.OrdersTest do
  use Trackster.DataCase

  alias Trackster.Orders

  describe "couriers" do
    alias Trackster.Orders.Courier

    import Trackster.OrdersFixtures

    @invalid_attrs %{name: nil, state: nil, phone: nil, city: nil, company: nil}

    test "list_couriers/0 returns all couriers" do
      courier = courier_fixture()
      assert Orders.list_couriers() == [courier]
    end

    test "get_courier!/1 returns the courier with given id" do
      courier = courier_fixture()
      assert Orders.get_courier!(courier.id) == courier
    end

    test "create_courier/1 with valid data creates a courier" do
      valid_attrs = %{name: "some name", state: "some state", phone: "some phone", city: "some city", company: "some company"}

      assert {:ok, %Courier{} = courier} = Orders.create_courier(valid_attrs)
      assert courier.name == "some name"
      assert courier.state == "some state"
      assert courier.phone == "some phone"
      assert courier.city == "some city"
      assert courier.company == "some company"
    end

    test "create_courier/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_courier(@invalid_attrs)
    end

    test "update_courier/2 with valid data updates the courier" do
      courier = courier_fixture()
      update_attrs = %{name: "some updated name", state: "some updated state", phone: "some updated phone", city: "some updated city", company: "some updated company"}

      assert {:ok, %Courier{} = courier} = Orders.update_courier(courier, update_attrs)
      assert courier.name == "some updated name"
      assert courier.state == "some updated state"
      assert courier.phone == "some updated phone"
      assert courier.city == "some updated city"
      assert courier.company == "some updated company"
    end

    test "update_courier/2 with invalid data returns error changeset" do
      courier = courier_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_courier(courier, @invalid_attrs)
      assert courier == Orders.get_courier!(courier.id)
    end

    test "delete_courier/1 deletes the courier" do
      courier = courier_fixture()
      assert {:ok, %Courier{}} = Orders.delete_courier(courier)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_courier!(courier.id) end
    end

    test "change_courier/1 returns a courier changeset" do
      courier = courier_fixture()
      assert %Ecto.Changeset{} = Orders.change_courier(courier)
    end
  end

  describe "addresses" do
    alias Trackster.Orders.Address

    import Trackster.OrdersFixtures

    @invalid_attrs %{state: nil, city: nil}

    test "list_addresses/0 returns all addresses" do
      address = address_fixture()
      assert Orders.list_addresses() == [address]
    end

    test "get_address!/1 returns the address with given id" do
      address = address_fixture()
      assert Orders.get_address!(address.id) == address
    end

    test "create_address/1 with valid data creates a address" do
      valid_attrs = %{state: "some state", city: "some city"}

      assert {:ok, %Address{} = address} = Orders.create_address(valid_attrs)
      assert address.state == "some state"
      assert address.city == "some city"
    end

    test "create_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_address(@invalid_attrs)
    end

    test "update_address/2 with valid data updates the address" do
      address = address_fixture()
      update_attrs = %{state: "some updated state", city: "some updated city"}

      assert {:ok, %Address{} = address} = Orders.update_address(address, update_attrs)
      assert address.state == "some updated state"
      assert address.city == "some updated city"
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = address_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_address(address, @invalid_attrs)
      assert address == Orders.get_address!(address.id)
    end

    test "delete_address/1 deletes the address" do
      address = address_fixture()
      assert {:ok, %Address{}} = Orders.delete_address(address)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_address!(address.id) end
    end

    test "change_address/1 returns a address changeset" do
      address = address_fixture()
      assert %Ecto.Changeset{} = Orders.change_address(address)
    end
  end

  describe "trackings" do
    alias Trackster.Orders.Tracking

    import Trackster.OrdersFixtures

    @invalid_attrs %{status: nil, description: nil, order_id: nil}

    test "list_trackings/0 returns all trackings" do
      tracking = tracking_fixture()
      assert Orders.list_trackings() == [tracking]
    end

    test "get_tracking!/1 returns the tracking with given id" do
      tracking = tracking_fixture()
      assert Orders.get_tracking!(tracking.id) == tracking
    end

    test "create_tracking/1 with valid data creates a tracking" do
      valid_attrs = %{status: "some status", description: "some description", order_id: 42}

      assert {:ok, %Tracking{} = tracking} = Orders.create_tracking(valid_attrs)
      assert tracking.status == "some status"
      assert tracking.description == "some description"
      assert tracking.order_id == 42
    end

    test "create_tracking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_tracking(@invalid_attrs)
    end

    test "update_tracking/2 with valid data updates the tracking" do
      tracking = tracking_fixture()
      update_attrs = %{status: "some updated status", description: "some updated description", order_id: 43}

      assert {:ok, %Tracking{} = tracking} = Orders.update_tracking(tracking, update_attrs)
      assert tracking.status == "some updated status"
      assert tracking.description == "some updated description"
      assert tracking.order_id == 43
    end

    test "update_tracking/2 with invalid data returns error changeset" do
      tracking = tracking_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_tracking(tracking, @invalid_attrs)
      assert tracking == Orders.get_tracking!(tracking.id)
    end

    test "delete_tracking/1 deletes the tracking" do
      tracking = tracking_fixture()
      assert {:ok, %Tracking{}} = Orders.delete_tracking(tracking)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_tracking!(tracking.id) end
    end

    test "change_tracking/1 returns a tracking changeset" do
      tracking = tracking_fixture()
      assert %Ecto.Changeset{} = Orders.change_tracking(tracking)
    end
  end

  describe "orders" do
    alias Trackster.Orders.Order

    import Trackster.OrdersFixtures

    @invalid_attrs %{order_tracking_id: nil, user_id: nil}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{order_tracking_id: "some order_tracking_id", user_id: 42}

      assert {:ok, %Order{} = order} = Orders.create_order(valid_attrs)
      assert order.order_tracking_id == "some order_tracking_id"
      assert order.user_id == 42
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      update_attrs = %{order_tracking_id: "some updated order_tracking_id", user_id: 43}

      assert {:ok, %Order{} = order} = Orders.update_order(order, update_attrs)
      assert order.order_tracking_id == "some updated order_tracking_id"
      assert order.user_id == 43
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
      assert order == Orders.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end
end
