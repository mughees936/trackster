defmodule TracksterWeb.TrackingLive.Index do
  use TracksterWeb, :live_view

  alias Trackster.Orders
  alias Trackster.Orders.Tracking

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :trackings, Orders.list_trackings())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tracking")
    |> assign(:tracking, Orders.get_tracking(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tracking")
    |> assign(:tracking, %Tracking{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Trackings")
    |> assign(:tracking, nil)
  end

  @impl true
  def handle_info({TracksterWeb.TrackingLive.FormComponent, {:saved, tracking}}, socket) do
    {:noreply, stream_insert(socket, :trackings, tracking)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tracking = Orders.get_tracking(id)
    {:ok, _} = Orders.delete_tracking(tracking)

    {:noreply, stream_delete(socket, :trackings, tracking)}
  end
end
