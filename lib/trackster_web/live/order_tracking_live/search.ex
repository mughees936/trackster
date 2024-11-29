defmodule TracksterWeb.OrderTrackingLive.Search do
  use TracksterWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div
      class={[
        "w-full mt-8 bg-transparent border shadow-current rounded-md dark:border-brand focus-within:border-brand ",
        "focus-within:ring focus-within:ring-brand dark:focus-within:border-brand focus-within:ring-opacity-40",
        @style == "reg" && "lg:max-w-lg"
      ]}
    >
      <form
        class="flex flex-col lg:flex-row"
        phx-change="query_change"
        phx-submit="search"
        phx-target={@myself}
      >
        <input
          type="text"
          phx-target={@myself}
          phx-change="query_change"
          name="search_query"
          value={@search_query}
          id="default-search"
          placeholder="Please enter your tracking number"
          class="flex-1 h-10 px-4 py-2 m-1 text-gray-700 placeholder-gray-400 bg-transparent border-none appearance-none dark:text-gray-200 focus:outline-none focus:placeholder-transparent focus:ring-0"
        />

        <button class="inline-flex h-10 px-4 py-2 m-1 bg-brand text-white font-semibold border border-brand rounded hover:bg-transparent hover:text-brand hover:border-brand transition ease-in duration-200">
          Search
          <span>
            <svg
              class="rtl:rotate-180 w-4 h-4 ms-2 pt-2"
              aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 14 10"
            >
              <path
                stroke="currentColor"
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M1 5h12m0 0L9 1m4 4L9 9"
              />
            </svg>
          </span>
        </button>
      </form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:style, Map.get(assigns, :style, "reg"))
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
