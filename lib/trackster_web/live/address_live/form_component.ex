defmodule TracksterWeb.AddressLive.FormComponent do
  use TracksterWeb, :live_component

  alias Trackster.Orders

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage address records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="address-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:state]} type="text" label="State" />
        <.input field={@form[:city]} type="text" label="City" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Address</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{address: address} = assigns, socket) do
    changeset = Orders.change_address(address)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"address" => address_params}, socket) do
    changeset =
      socket.assigns.address
      |> Orders.change_address(address_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"address" => address_params}, socket) do
    save_address(socket, socket.assigns.action, address_params)
  end

  defp save_address(socket, :edit, address_params) do
    case Orders.update_address(socket.assigns.address, address_params) do
      {:ok, address} ->
        notify_parent({:saved, address})

        {:noreply,
         socket
         |> put_flash(:info, "Address updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_address(socket, :new, address_params) do
    case Orders.create_address(address_params) do
      {:ok, address} ->
        notify_parent({:saved, address})

        {:noreply,
         socket
         |> put_flash(:info, "Address created successfully")
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
