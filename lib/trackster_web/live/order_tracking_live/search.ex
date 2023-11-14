defmodule TracksterWeb.OrderTrackingLive.Search do
  use TracksterWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="text-center px-3 lg:px-0">
        <h1 class="my-4 text-2xl md:text-3xl lg:text-5xl font-black leading-tight">
          Delivering excellence, every mile of the way.
        </h1>
        <p class="leading-normal text-gray-800 text-base md:text-xl lg:text-2xl mb-8">
          Fast, secure, and reliable courier services for your peace of mind.
        </p>
      </div>
      <form phx-change="query_change" phx-submit="search" phx-target={@myself}>
        <label
          for="default-search"
          class="mb-2 text-sm font-medium text-gray-900 sr-only dark:text-white"
        >
          Search
        </label>
        <div class="flex justify-center mb-8">
          <div class="relative w-1/2">
            <div class="absolute inset-y-0 start-0 flex items-center ps-3 pointer-events-none">
              <svg
                class="w-4 h-4 text-gray-500 dark:text-gray-400"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 20 20"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z"
                />
              </svg>
            </div>
            <input
              phx-target={@myself}
              phx-change="query_change"
              name="search_query"
              value={@search_query}
              type="text"
              id="default-search"
              class="block w-full p-4 ps-10 text-sm text-gray-900 border border-gray-300 bg-gray-50 focus:ring-brand focus:border-brand dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-brand-500 dark:focus:border-brand-500"
              placeholder="Please enter your tracking number to track the shipment status in real time"
              required
            />
            <div class="absolute end-2.5 bottom-2.5 text-sm">
              <div class="flex flex-col justify-center items-center w-full bg-brand">
                <button
                  type="button"
                  phx-target={@myself}
                  phx-click="search"
                  class="relative text-center h-9 w-40 transition-all duration-500
            before:absolute before:top-0 before:left-0 before:w-full before:h-full before:bg-brand/4 before:transition-all
            before:duration-300 before:opacity-10 before:hover:opacity-0 before:hover:scale-50
            after:absolute after:top-0 after:left-0 after:w-full after:h-full after:opacity-0 after:transition-all after:duration-300
            after:border after:border-brand after:scale-125 after:hover:opacity-100 after:hover:scale-100"
                >
                  <span class="relative text-white uppercase">Search</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:search_query, Map.get(assigns, :search_query, ""))}
  end

  @impl true
  def handle_event("query_change", %{"search_query" => id}, socket) do
    {:noreply, assign(socket, :search_query, id)}
  end

  @impl true
  def handle_event("search", _params, socket) do
    socket =
      socket
      |> push_navigate(to: ~p"/tracking/#{socket.assigns.search_query}")

    {:noreply, socket}
  end
end
