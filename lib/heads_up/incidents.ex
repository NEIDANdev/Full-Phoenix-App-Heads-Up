defmodule HeadsUp.Incidents do
  import Ecto.Query

  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Repo

  def list_incidents() do
    Repo.all(Incident)
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def urgent_incidents(incident) do
    Incident
    |> where([i], i.name != ^incident.name)
    |> limit(3)
    |> Repo.all()
  end

  def filter_incidents(filters) do
    Incident
    |> where(status: ^filters["status"])
    |> where([incident], ilike(incident.name, ^"%#{filters["q"]}%"))
    |> order_by( desc: :name)
    |> Repo.all()
  end
end
