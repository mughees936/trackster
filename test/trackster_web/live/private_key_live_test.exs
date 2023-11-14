defmodule TracksterWeb.PrivateKeyLiveTest do
  use TracksterWeb.ConnCase

  import Phoenix.LiveViewTest
  import Trackster.AccountsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_private_key(_) do
    private_key = private_key_fixture()
    %{private_key: private_key}
  end

  describe "Index" do
    setup [:create_private_key]

    test "lists all private_keys", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/private_keys")

      assert html =~ "Listing Private keys"
    end

    test "saves new private_key", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/private_keys")

      assert index_live |> element("a", "New Private key") |> render_click() =~
               "New Private key"

      assert_patch(index_live, ~p"/private_keys/new")

      assert index_live
             |> form("#private_key-form", private_key: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#private_key-form", private_key: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/private_keys")

      html = render(index_live)
      assert html =~ "Private key created successfully"
    end

    test "updates private_key in listing", %{conn: conn, private_key: private_key} do
      {:ok, index_live, _html} = live(conn, ~p"/private_keys")

      assert index_live |> element("#private_keys-#{private_key.id} a", "Edit") |> render_click() =~
               "Edit Private key"

      assert_patch(index_live, ~p"/private_keys/#{private_key}/edit")

      assert index_live
             |> form("#private_key-form", private_key: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#private_key-form", private_key: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/private_keys")

      html = render(index_live)
      assert html =~ "Private key updated successfully"
    end

    test "deletes private_key in listing", %{conn: conn, private_key: private_key} do
      {:ok, index_live, _html} = live(conn, ~p"/private_keys")

      assert index_live |> element("#private_keys-#{private_key.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#private_keys-#{private_key.id}")
    end
  end

  describe "Show" do
    setup [:create_private_key]

    test "displays private_key", %{conn: conn, private_key: private_key} do
      {:ok, _show_live, html} = live(conn, ~p"/private_keys/#{private_key}")

      assert html =~ "Show Private key"
    end

    test "updates private_key within modal", %{conn: conn, private_key: private_key} do
      {:ok, show_live, _html} = live(conn, ~p"/private_keys/#{private_key}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Private key"

      assert_patch(show_live, ~p"/private_keys/#{private_key}/show/edit")

      assert show_live
             |> form("#private_key-form", private_key: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#private_key-form", private_key: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/private_keys/#{private_key}")

      html = render(show_live)
      assert html =~ "Private key updated successfully"
    end
  end
end
