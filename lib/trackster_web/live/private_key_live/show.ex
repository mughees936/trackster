defmodule TracksterWeb.PrivateKeyLive.Show do
  use TracksterWeb, :live_view

  alias Trackster.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:private_key, Accounts.get_private_key!(id))}
  end

  defp page_title(:show), do: "Show Private key"
  defp page_title(:edit), do: "Edit Private key"
end
