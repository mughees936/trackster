defmodule TracksterWeb.RedoLiveTest do
  use TracksterWeb.ConnCase

  import Phoenix.LiveViewTest
  import Trackster.DeleteFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_redo(_) do
    redo = redo_fixture()
    %{redo: redo}
  end

  describe "Index" do
    setup [:create_redo]

    test "lists all deletes", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/deletes")

      assert html =~ "Listing Deletes"
    end

    test "saves new redo", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/deletes")

      assert index_live |> element("a", "New Redo") |> render_click() =~
               "New Redo"

      assert_patch(index_live, ~p"/deletes/new")

      assert index_live
             |> form("#redo-form", redo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#redo-form", redo: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/deletes")

      html = render(index_live)
      assert html =~ "Redo created successfully"
    end

    test "updates redo in listing", %{conn: conn, redo: redo} do
      {:ok, index_live, _html} = live(conn, ~p"/deletes")

      assert index_live |> element("#deletes-#{redo.id} a", "Edit") |> render_click() =~
               "Edit Redo"

      assert_patch(index_live, ~p"/deletes/#{redo}/edit")

      assert index_live
             |> form("#redo-form", redo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#redo-form", redo: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/deletes")

      html = render(index_live)
      assert html =~ "Redo updated successfully"
    end

    test "deletes redo in listing", %{conn: conn, redo: redo} do
      {:ok, index_live, _html} = live(conn, ~p"/deletes")

      assert index_live |> element("#deletes-#{redo.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#deletes-#{redo.id}")
    end
  end

  describe "Show" do
    setup [:create_redo]

    test "displays redo", %{conn: conn, redo: redo} do
      {:ok, _show_live, html} = live(conn, ~p"/deletes/#{redo}")

      assert html =~ "Show Redo"
    end

    test "updates redo within modal", %{conn: conn, redo: redo} do
      {:ok, show_live, _html} = live(conn, ~p"/deletes/#{redo}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Redo"

      assert_patch(show_live, ~p"/deletes/#{redo}/show/edit")

      assert show_live
             |> form("#redo-form", redo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#redo-form", redo: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/deletes/#{redo}")

      html = render(show_live)
      assert html =~ "Redo updated successfully"
    end
  end
end
