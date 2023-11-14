defmodule TracksterWeb.TrackingLive.Show do
  use TracksterWeb, :live_view

  alias Trackster.Orders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:tracking, Orders.get_tracking!(id))}
  end

  defp page_title(:show), do: "Show Tracking"
  defp page_title(:edit), do: "Edit Tracking"
end
