defmodule TracksterWeb.HomeLive.Index do
  use TracksterWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_session_user(socket, session)}
  end

  # after enabling about other pages
  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :order_tracking, %{"id" => id}) do
    IO.inspect(id, label: "IDDD")

    socket
    |> assign(:page_title, "Edit Address")
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Addresses")
  end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Address")
  # end

  # @impl true
  # def handle_info({TracksterWeb.AddressLive.FormComponent, {:saved, address}}, socket) do
  #   {:noreply, stream_insert(socket, :addresses, address)}
  # end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    IO.inspect(query, label: "Query")

    {:noreply, socket}
  end

  defp assign_session_user(socket, session) do
    with %Trackster.Accounts.User{} = user <- verify_user_token(session) do
      assign(socket, :current_user, user)
    else
      _ ->
        assign(socket, :current_user, nil)
    end
  end
end
