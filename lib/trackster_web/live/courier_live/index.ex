defmodule TracksterWeb.CourierLive.Index do
  use TracksterWeb, :live_view

  alias Trackster.Orders
  alias Trackster.Orders.Courier

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :couriers, Orders.list_couriers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Courier")
    |> assign(:courier, Orders.get_courier!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Courier")
    |> assign(:courier, %Courier{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Couriers")
    |> assign(:courier, nil)
  end

  @impl true
  def handle_info({TracksterWeb.CourierLive.FormComponent, {:saved, courier}}, socket) do
    {:noreply, stream_insert(socket, :couriers, courier)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    courier = Orders.get_courier!(id)
    {:ok, _} = Orders.delete_courier(courier)

    {:noreply, stream_delete(socket, :couriers, courier)}
  end
end
