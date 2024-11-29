defmodule Trackster.Workers.TrackingsHandler do
  use GenServer

  import Ecto.Query, warn: false

  alias Trackster.Repo
  alias Ecto.Multi
  alias Trackster.Orders
  alias Trackster.Orders.{Tracking, Order}

  require Logger

  # interval for every cycle in seconds
  @cycle_interval 30

  @delay_after_insertation 60

  @delay_after_creation 60

  @delay_after_pickup 60

  @delay_after_left_pickup_state 60

  @delay_after_left_pickup_city 60

  @delay_after_arrived_drop_state 60

  @delay_after_arrived_drop_city 60

  @delay_after_delivering 60

  @delay_mapping %{
    "not_initiated" => @delay_after_insertation,
    "creation" => @delay_after_creation,
    "pickup" => @delay_after_pickup,
    "left_pickup_state" => @delay_after_left_pickup_state,
    "left_pickup_city" => @delay_after_left_pickup_city,
    "arrived_drop_state" => @delay_after_arrived_drop_state,
    "arrived_drop_city" => @delay_after_arrived_drop_city,
    "delivering" => @delay_after_delivering
  }

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    # Schedule work to be performed on start
    schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_info(:update_orders, state) do
    process_orders()
    schedule_work()

    {:noreply, state}
  end

  def process_orders() do
    Logger.debug("Work started")

    Order.get_valid_order_status()
    |> Enum.each(&process_order_stage/1)
  end

  defp process_order_stage(status) do
    timestamp = get_timestamp(status)

    case Orders.get_past_due_in_status(status, timestamp) do
      [] -> Logger.debug("No due orders in #{status}")
      orders -> Enum.map(orders, &create_tracking/1)
    end
  end

  defp create_tracking(order) do
    attrs = create_tracking_attrs(order)

    current_tracking =
      List.last(order.trackings)
      |> IO.inspect(label: "Here os head")

    Multi.new()
    |> Ecto.Multi.update_all(:update_all, Orders.order_trackings_query(order.id),
      set: [is_active: false]
    )
    |> Multi.insert(:tracking, Tracking.changeset(attrs))
    |> Multi.update(:order, fn %{tracking: tracking} ->
      Order.status_changeset(order, tracking.status)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _result} ->
        Logger.info("#{order.id} order updated successfully")
        :ok

      {:error, reason} ->
        Logger.error("Failed to update order: #{reason}")
        {:error, reason}
    end
  end

  defp get_timestamp(status) do
    delay = Map.get(@delay_mapping, status, 0)
    Timex.now() |> Timex.shift(seconds: -delay)
  end

  defp create_tracking_attrs(%Order{
         status: status,
         dispatch_courier: dispatch_courier,
         recieving_courier: recieving_courier,
         pickup_address: pickup,
         drop_address: drop,
         id: id
       }) do
    description =
      case status do
        "not_initiated" ->
          "Order created"

        "creation" ->
          "[#{pickup.state}] Tracksters courier #{dispatch_courier.name} has picked up the parcel. If you have queries, please call [company num]"

        "pickup" ->
          "The parcel left [#{pickup.city}] station and was sent to [#{pickup.state}] sorting center."

        "left_pickup_city" ->
          "The parcel left [#{pickup.state}] sorting center and was sent to [#{drop.state}]"

        "left_pickup_state" ->
          "The parcel has arrived at [#{drop.state}] sorting center."

        "arrived_drop_state" ->
          "The parcel left [#{drop.state}] sorting center and was sent to [#{drop.city}]."

        "arrived_drop_city" ->
          "The parcel has arrived at [#{drop.city}] station"

        "delivering" ->
          "Trackster [#{drop.city}]'s courier #{recieving_courier.name}(#{recieving_courier.phone}) is out for delivery with your order, you can contact him for any special request or call [company num] for any other queries."
      end

    %{
      "order_id" => id,
      "description" => description,
      "status" => next_status(status)
    }
  end

  defp next_status("not_initiated"), do: "creation"
  defp next_status("creation"), do: "pickup"
  defp next_status("pickup"), do: "left_pickup_city"
  defp next_status("left_pickup_city"), do: "left_pickup_state"
  defp next_status("left_pickup_state"), do: "arrived_drop_state"
  defp next_status("arrived_drop_state"), do: "arrived_drop_city"
  defp next_status("arrived_drop_city"), do: "delivering"
  defp next_status("delivering"), do: "signed"

  defp schedule_work do
    Process.send_after(self(), :update_orders, :timer.seconds(30))
  end
end
