defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUpWeb.CustomComponents
  alias HeadsUp.Incidents

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    incidents = Incidents.list_incidents()

    socket =
      socket
      |> stream(:incidents, incidents)
      |> assign(page_title: "Incidents")
      |> assign(:form, to_form(%{}))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
      <CustomComponents.headline>
        <.icon name="hero-trophy-mini" /> 25 Incidents Resolved This Month!
        <:tagline :let={vibe}>
          Thanks for pitching in. {vibe}
        </:tagline>
      </CustomComponents.headline>

      <.filter_form form={@form} />

      <div class="incidents">
        <CustomComponents.incident_cards
          :for={{dom_id, incident} <- @streams.incidents}
          incident={incident}
          id={dom_id}
        />
      </div>
    </div>
    """
  end

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter">
      <.input field={@form[:q]} placeholder="Incident Name" autocomplete="off" phx-debounce="500" />
      <.input
        type="select"
        field={@form[:status]}
        prompt="Status"
        options={[:pending, :resolved, :canceled]}
      />
      <.input
        type="select"
        field={@form[:sort_by]}
        prompt="Sort by"
        options={[
          Name: "name",
          "Priority: High to Low": "priority_desc",
          "Priority: Low to High": "priority_asc"
        ]}
      />
    </.form>
    """
  end

  def handle_event("filter", filters, socket) do
    socket =
      socket
      |> assign(:form, to_form(filters))
      |> stream(:incidents, Incidents.filter_incidents(filters), reset: true)

    {:noreply, socket}
  end
end
