defmodule HeadsUpWeb.CustomComponents do
  use HeadsUpWeb, :html

  attr :class, :string, default: nil
  attr :status, :atom, values: [:pending, :resolved, :canceled], default: :pending

  def badge(assigns) do
    ~H"""
    <div class={[
      "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border",
      @status == :resolved && "text-lime-600 border-lime-600",
      @status == :pending && "text-amber-600 border-amber-600",
      @status == :canceled && "text-gray-600 border-gray-600"
    ]}>
      {@status}
    </div>
    """
  end

  slot :inner_block, required: true
  slot :tagline, required: false

  def headline(assigns) do
    assigns = assign(assigns, :emoji, ~w(🤩 😎 😱) |> Enum.random())

    ~H"""
    <div class="headline">
      <h1>
        {render_slot(@inner_block)}
      </h1>
      <div class="tagline">
        {render_slot(@tagline, @emoji)}
      </div>
    </div>
    """
  end

  attr :incident, HeadsUp.Incidents.Incident, required: true
  attr :id, :string, required: true

  def incident_cards(assigns) do
    ~H"""
    <.link navigate={~p"/#{@incident}"} id={@id}>
      <div class="card">
        <img src={@incident.image_path} />
        <h2>{@incident.name}</h2>
        <div class="details">
          <.badge status={@incident.status} />
          <div class="priority">
            {@incident.priority}
          </div>
        </div>
      </div>
    </.link>
    """
  end

  attr :incidents, :list, required: true

  def urgent_incidents(assigns) do
    ~H"""
    <section>
      <h4>Urgent Incidents</h4>
      <ul class="incidents">
        <li :for={incident <- @incidents}>
          <.link navigate={~p"/#{incident}"}>
            <img src={incident.image_path} />
            {incident.name}
          </.link>
        </li>
      </ul>
    </section>
    """
  end
end
