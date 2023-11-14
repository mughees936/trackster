defmodule TracksterWeb.CourierLive.FormComponent do
  use TracksterWeb, :live_component

  alias Trackster.Orders

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage courier records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="courier-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:phone]} type="text" label="Phone" />
        <.input field={@form[:state]} type="text" label="State" />
        <.input field={@form[:city]} type="text" label="City" />
        <.input field={@form[:company]} type="text" label="Company" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Courier</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{courier: courier} = assigns, socket) do
    changeset = Orders.change_courier(courier)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"courier" => courier_params}, socket) do
    changeset =
      socket.assigns.courier
      |> Orders.change_courier(courier_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"courier" => courier_params}, socket) do
    save_courier(socket, socket.assigns.action, courier_params)
  end

  defp save_courier(socket, :edit, courier_params) do
    case Orders.update_courier(socket.assigns.courier, courier_params) do
      {:ok, courier} ->
        notify_parent({:saved, courier})

        {:noreply,
         socket
         |> put_flash(:info, "Courier updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_courier(socket, :new, courier_params) do
    case Orders.create_courier(courier_params) do
      {:ok, courier} ->
        notify_parent({:saved, courier})

        {:noreply,
         socket
         |> put_flash(:info, "Courier created successfully")
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
