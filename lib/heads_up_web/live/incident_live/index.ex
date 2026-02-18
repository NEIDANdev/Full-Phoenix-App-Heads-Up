defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    incidents = HeadsUp.Incidents.list_incidents()

    socket =
      socket
      |> assign(incidents: incidents)
      |> assign(page_title: "Incidents")

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
      <div class="incidents">
        <CustomComponents.incident_cards incidents={@incidents} />
      </div>
    </div>
    """
  end
end
