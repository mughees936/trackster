defmodule TracksterWeb.AddressLive.Index do
  use TracksterWeb, :live_view

  alias Trackster.Orders
  alias Trackster.Orders.Address

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :addresses, Orders.list_addresses())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Address")
    |> assign(:address, Orders.get_address!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Address")
    |> assign(:address, %Address{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Addresses")
    |> assign(:address, nil)
  end

  @impl true
  def handle_info({TracksterWeb.AddressLive.FormComponent, {:saved, address}}, socket) do
    {:noreply, stream_insert(socket, :addresses, address)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    address = Orders.get_address!(id)
    {:ok, _} = Orders.delete_address(address)

    {:noreply, stream_delete(socket, :addresses, address)}
  end
end
