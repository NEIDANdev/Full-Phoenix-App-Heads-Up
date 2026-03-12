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
    |> with_status(filters["status"])
    |> search_by(filters["q"])
    |> sort(filters["sort_by"])
    |> Repo.all()
  end

  defp with_status(query, status) when status in ~w(pending resolved canceled) do
    where(query, status: ^status)
  end

  defp with_status(query, _), do: query

  defp search_by(query, q) when q in ["", nil], do: query

  defp search_by(query, q) do
    where(query, [incident], ilike(incident.name, ^"%#{q}%"))
  end

  defp sort(query, filters) do
    case filters do
      "name" -> order_by(query, :name)
      "priority_desc" -> order_by(query, desc: :priority)
      "priority_asc" -> order_by(query, asc: :priority)
      _ -> order_by(query, :id)
    end
  end
end
