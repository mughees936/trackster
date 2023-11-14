defmodule TracksterWeb.PrivateKeyLive.FormComponent do
  use TracksterWeb, :live_component

  alias Trackster.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage private_key records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="private_key-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Private key</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{private_key: private_key} = assigns, socket) do
    changeset = Accounts.change_private_key(private_key)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"private_key" => private_key_params}, socket) do
    changeset =
      socket.assigns.private_key
      |> Accounts.change_private_key(private_key_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"private_key" => private_key_params}, socket) do
    save_private_key(socket, socket.assigns.action, private_key_params)
  end

  defp save_private_key(socket, :edit, private_key_params) do
    case Accounts.update_private_key(socket.assigns.private_key, private_key_params) do
      {:ok, private_key} ->
        notify_parent({:saved, private_key})

        {:noreply,
         socket
         |> put_flash(:info, "Private key updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_private_key(socket, :new, private_key_params) do
    case Accounts.create_private_key(private_key_params) do
      {:ok, private_key} ->
        notify_parent({:saved, private_key})

        {:noreply,
         socket
         |> put_flash(:info, "Private key created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
