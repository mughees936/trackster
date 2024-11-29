defmodule TracksterWeb.OrderLive.Index do
  use TracksterWeb, :live_view

  alias Trackster.Accounts
  alias Trackster.Accounts.User
  alias Trackster.Orders
  alias Trackster.Orders.Order

  @impl true
  def mount(_params, session, socket) do
    IO.inspect(session, label: "params")

    with user = %User{} <- Accounts.get_user_by_session_token(session["user_token"]) do
      {:ok,
       socket
       |> assign(:current_user_id, user.id)
       |> stream(:orders, Orders.list_user_orders(user.id))}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Order")
    |> assign(:order, Orders.get_order!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Order")
    |> assign(:order, %Order{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:active_filter, :view_all)
    |> assign(:page_title, "Listing Orders")
    |> assign(:order, nil)
  end

  @impl true
  def handle_info({TracksterWeb.OrderLive.FormComponent, {:saved, order}}, socket) do
    {:noreply, stream_insert(socket, :orders, order)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    order = Orders.get_order!(id)
    {:ok, _} = Orders.delete_order(order)

    {:noreply, stream_delete(socket, :orders, order)}
  end

  @impl true
  def handle_event("filter", %{"value" => filter}, socket) do
    {:noreply,
     socket
     |> assign(:active_filter, String.to_atom(filter))}
  end
end
