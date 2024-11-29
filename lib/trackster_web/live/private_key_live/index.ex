defmodule TracksterWeb.PrivateKeyLive.Index do
  use TracksterWeb, :live_view

  alias Trackster.Accounts
  alias Trackster.Accounts.PrivateKey

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :private_keys, Accounts.list_private_keys())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Private key")
    |> assign(:private_key, Accounts.get_private_key(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Private key")
    |> assign(:private_key, %PrivateKey{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Private keys")
    |> assign(:private_key, nil)
  end

  @impl true
  def handle_info({TracksterWeb.PrivateKeyLive.FormComponent, {:saved, private_key}}, socket) do
    {:noreply, stream_insert(socket, :private_keys, private_key)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    private_key = Accounts.get_private_key(id)
    {:ok, _} = Accounts.delete_private_key(private_key)

    {:noreply, stream_delete(socket, :private_keys, private_key)}
  end
end
