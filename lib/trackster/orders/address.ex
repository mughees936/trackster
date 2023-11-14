defmodule Trackster.Orders.Address do
  use Trackster.Schema

  alias Trackster.Orders.Address

  schema "addresses" do
    field :state, :string
    field :city, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:state, :city])
    |> validate_required([:state, :city])
  end

  def create_addresses_for_state_and_cities() do
    fetch_cities_for_country()
    |> Enum.map(&create_address(&1["state"], &1["city"]))
  end

  def fetch_cities_for_country(country_name \\ "United Arab Emirates") do
    fetch_states_for_country(country_name)
    |> Enum.flat_map(&fetch_cities_for_state_of_country(country_name, &1["name"]))
  end

  defp fetch_states_for_country(country_name) do
    url = "https://countriesnow.space/api/v0.1/countries/states/q?country=#{country_name}"

    case get_request(url) do
      %{"states" => states} ->
        states

      _ ->
        []
    end
  end

  defp fetch_cities_for_state_of_country(country_name, state_name) do
    url =
      "https://countriesnow.space/api/v0.1/countries/state/cities/q?country=#{country_name}&state=#{state_name}"

    get_request(url)
    |> Enum.map(fn city ->
      %{"state" => state_name, "city" => city}
    end)
  end

  defp get_request(url) do
    case HTTPoison.get(url) do
      {:ok, %{body: body}} ->
        Jason.decode!(body)["data"]

      {:error, _} ->
        []
    end
  end

  defp create_address(state, city) do
    changeset(%Address{}, %{"state" => state, "city" => city})
    |> Trackster.Repo.insert!()
  end
end
