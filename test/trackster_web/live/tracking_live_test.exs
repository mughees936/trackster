defmodule TracksterWeb.TrackingLiveTest do
  use TracksterWeb.ConnCase

  import Phoenix.LiveViewTest
  import Trackster.OrdersFixtures

  @create_attrs %{status: "some status", description: "some description", order_id: 42}
  @update_attrs %{status: "some updated status", description: "some updated description", order_id: 43}
  @invalid_attrs %{status: nil, description: nil, order_id: nil}

  defp create_tracking(_) do
    tracking = tracking_fixture()
    %{tracking: tracking}
  end

  describe "Index" do
    setup [:create_tracking]

    test "lists all trackings", %{conn: conn, tracking: tracking} do
      {:ok, _index_live, html} = live(conn, ~p"/trackings")

      assert html =~ "Listing Trackings"
      assert html =~ tracking.status
    end

    test "saves new tracking", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/trackings")

      assert index_live |> element("a", "New Tracking") |> render_click() =~
               "New Tracking"

      assert_patch(index_live, ~p"/trackings/new")

      assert index_live
             |> form("#tracking-form", tracking: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#tracking-form", tracking: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/trackings")

      html = render(index_live)
      assert html =~ "Tracking created successfully"
      assert html =~ "some status"
    end

    test "updates tracking in listing", %{conn: conn, tracking: tracking} do
      {:ok, index_live, _html} = live(conn, ~p"/trackings")

      assert index_live |> element("#trackings-#{tracking.id} a", "Edit") |> render_click() =~
               "Edit Tracking"

      assert_patch(index_live, ~p"/trackings/#{tracking}/edit")

      assert index_live
             |> form("#tracking-form", tracking: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#tracking-form", tracking: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/trackings")

      html = render(index_live)
      assert html =~ "Tracking updated successfully"
      assert html =~ "some updated status"
    end

    test "deletes tracking in listing", %{conn: conn, tracking: tracking} do
      {:ok, index_live, _html} = live(conn, ~p"/trackings")

      assert index_live |> element("#trackings-#{tracking.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#trackings-#{tracking.id}")
    end
  end

  describe "Show" do
    setup [:create_tracking]

    test "displays tracking", %{conn: conn, tracking: tracking} do
      {:ok, _show_live, html} = live(conn, ~p"/trackings/#{tracking}")

      assert html =~ "Show Tracking"
      assert html =~ tracking.status
    end

    test "updates tracking within modal", %{conn: conn, tracking: tracking} do
      {:ok, show_live, _html} = live(conn, ~p"/trackings/#{tracking}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Tracking"

      assert_patch(show_live, ~p"/trackings/#{tracking}/show/edit")

      assert show_live
             |> form("#tracking-form", tracking: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#tracking-form", tracking: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/trackings/#{tracking}")

      html = render(show_live)
      assert html =~ "Tracking updated successfully"
      assert html =~ "some updated status"
    end
  end
end
