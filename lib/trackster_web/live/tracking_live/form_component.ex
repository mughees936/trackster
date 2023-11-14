defmodule TracksterWeb.TrackingLive.FormComponent do
  use TracksterWeb, :live_component

  alias Trackster.Orders

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage tracking records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="tracking-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:status]} type="text" label="Status" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:order_id]} type="number" label="Order" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Tracking</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{tracking: tracking} = assigns, socket) do
    changeset = Orders.change_tracking(tracking)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"tracking" => tracking_params}, socket) do
    changeset =
      socket.assigns.tracking
      |> Orders.change_tracking(tracking_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"tracking" => tracking_params}, socket) do
    save_tracking(socket, socket.assigns.action, tracking_params)
  end

  defp save_tracking(socket, :edit, tracking_params) do
    case Orders.update_tracking(socket.assigns.tracking, tracking_params) do
      {:ok, tracking} ->
        notify_parent({:saved, tracking})

        {:noreply,
         socket
         |> put_flash(:info, "Tracking updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_tracking(socket, :new, tracking_params) do
    case Orders.create_tracking(tracking_params) do
      {:ok, tracking} ->
        notify_parent({:saved, tracking})

        {:noreply,
         socket
         |> put_flash(:info, "Tracking created successfully")
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
