defmodule TracksterWeb.OrderTrackingLive.Index do
  use TracksterWeb, :live_view

  alias Trackster.Orders

  @impl true
  def mount(%{"id" => order_tracking}, _session, socket) do
    {:ok,
     socket
     |> assign(:search_query, order_tracking)
     |> assign(:order, Orders.maybe_get_order_by_tracking(order_tracking))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Trackings")
    |> assign(:tracking, nil)
  end
end
