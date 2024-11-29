defmodule TracksterWeb.Helpers do
  def format_address(%Trackster.Orders.Address{state: state, city: city}), do: "#{city}, #{state}"

  def keep_first_n_words(str, n \\ 2) do
    String.split(str, ~r/\s+/)
    |> Enum.take(n)
    |> Enum.join(" ")
  end

  def utc_to_human_readable(utc_datetime) do
    with {:ok, formatted_date} <- Timex.format(utc_datetime, "{RFC1123z}"),
         [day, date, month, year, time, _tz] <- String.split(formatted_date, " ") do
      [hours, mins, _secs] = String.split(time, ":")

      "#{day} #{date} #{month} #{year} #{hours}:#{mins}"
      |> IO.inspect(label: "Human-readable")
    else
      err -> IO.inspect(err, label: "Invalid UTC datetime for conversion")
    end
  end

  def order_number(id), do: "##{String.slice(id, -5..-1)}"

  def status_text(status) do
    case status do
      "creation" -> "Created"
      "pickup" -> "Picked Up"
      "delivering" -> "Delivering"
      "signed" -> "Order Signed"
      _ -> "In Transit"
    end
  end

  def order_tracking_description(%Trackster.Orders.Order{trackings: trackings}) do
    List.last(trackings).description
    |> IO.inspect(label: "Description")
  end

  def verify_user_token(%{"user_token" => token}) when not is_nil(token) do
    Trackster.Accounts.get_user_by_session_token(token)
  end

  def verify_user_token(p), do: IO.inspect(p, label: "Session nil")
end
