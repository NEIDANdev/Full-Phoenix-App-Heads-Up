defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      assign(socket, :incidents, HeadsUp.Incidents.list_incidents())

    {:ok, socket}
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
        <.incident_card :for={incident <- @incidents} incident={incident} />
      </div>
    </div>
    """
  end

  def incident_card(assigns) do
    ~H"""
    <div class="card">
      <img src={@incident.image_path} />
      <h2>{@incident.name}</h2>
      <div class="details">
        <CustomComponents.badge status={@incident.status} />
        <div class="priority">
          {@incident.priority}
        </div>
      </div>
    </div>
    """
  end
end
