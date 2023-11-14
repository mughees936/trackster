defmodule TracksterWeb.Helpers do
  def format_address(%Trackster.Orders.Address{state: state, city: city}), do: "#{city}, #{state}"

  def trunc_address(%Trackster.Orders.Address{state: state, city: city}),
    do: "#{keep_first_two_words(state)} - #{keep_first_two_words(city)}"

  defp keep_first_two_words(str) do
    String.split(str, ~r/\s+/)
    |> Enum.take(2)
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

  def verify_user_token(%{"user_token" => token}) when not is_nil(token) do
    Trackster.Accounts.get_user_by_session_token(token)
  end

  def verify_user_token(p), do: IO.inspect(p, label: "Session nil")
end
