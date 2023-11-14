defmodule TracksterWeb.CourierLiveTest do
  use TracksterWeb.ConnCase

  import Phoenix.LiveViewTest
  import Trackster.OrdersFixtures

  @create_attrs %{name: "some name", state: "some state", phone: "some phone", city: "some city", company: "some company"}
  @update_attrs %{name: "some updated name", state: "some updated state", phone: "some updated phone", city: "some updated city", company: "some updated company"}
  @invalid_attrs %{name: nil, state: nil, phone: nil, city: nil, company: nil}

  defp create_courier(_) do
    courier = courier_fixture()
    %{courier: courier}
  end

  describe "Index" do
    setup [:create_courier]

    test "lists all couriers", %{conn: conn, courier: courier} do
      {:ok, _index_live, html} = live(conn, ~p"/couriers")

      assert html =~ "Listing Couriers"
      assert html =~ courier.name
    end

    test "saves new courier", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/couriers")

      assert index_live |> element("a", "New Courier") |> render_click() =~
               "New Courier"

      assert_patch(index_live, ~p"/couriers/new")

      assert index_live
             |> form("#courier-form", courier: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#courier-form", courier: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/couriers")

      html = render(index_live)
      assert html =~ "Courier created successfully"
      assert html =~ "some name"
    end

    test "updates courier in listing", %{conn: conn, courier: courier} do
      {:ok, index_live, _html} = live(conn, ~p"/couriers")

      assert index_live |> element("#couriers-#{courier.id} a", "Edit") |> render_click() =~
               "Edit Courier"

      assert_patch(index_live, ~p"/couriers/#{courier}/edit")

      assert index_live
             |> form("#courier-form", courier: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#courier-form", courier: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/couriers")

      html = render(index_live)
      assert html =~ "Courier updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes courier in listing", %{conn: conn, courier: courier} do
      {:ok, index_live, _html} = live(conn, ~p"/couriers")

      assert index_live |> element("#couriers-#{courier.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#couriers-#{courier.id}")
    end
  end

  describe "Show" do
    setup [:create_courier]

    test "displays courier", %{conn: conn, courier: courier} do
      {:ok, _show_live, html} = live(conn, ~p"/couriers/#{courier}")

      assert html =~ "Show Courier"
      assert html =~ courier.name
    end

    test "updates courier within modal", %{conn: conn, courier: courier} do
      {:ok, show_live, _html} = live(conn, ~p"/couriers/#{courier}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Courier"

      assert_patch(show_live, ~p"/couriers/#{courier}/show/edit")

      assert show_live
             |> form("#courier-form", courier: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#courier-form", courier: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/couriers/#{courier}")

      html = render(show_live)
      assert html =~ "Courier updated successfully"
      assert html =~ "some updated name"
    end
  end
end
