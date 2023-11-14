defmodule TracksterWeb.OrderLive.Show do
  use TracksterWeb, :live_view

  alias Trackster.Orders
  alias Trackster.Accounts

  @impl true
  def mount(_params, session, socket) do
    with user <- Accounts.get_user_by_session_token(session["user_token"]) do
      {:ok,
       socket
       |> assign(:current_user_id, user.id)}
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:order, Orders.get_order!(id))}
  end

  defp page_title(:show), do: "Show Order"
  defp page_title(:edit), do: "Edit Order"
end
