defmodule AccessCampusApiWeb.CampusController do
  use AccessCampusApiWeb, :controller

  alias AccessCampusApi.Repo
  alias AccessCampusApi.Entrances
  alias AccessCampusApi.Entrances.Campus

  action_fallback AccessCampusApiWeb.FallbackController

  def index(conn, _params) do
    campuses = Entrances.list_campuses()
    render(conn, "index.json-api", data: campuses)
  end

  def create(conn, %{"campus" => campus_params}) do
    with {:ok, %Campus{} = campus} <- Entrances.create_campus(campus_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.campus_path(conn, :show, campus))
      |> render("show.json-api", data: campus)
    end
  end

  def show(conn, %{"id" => id}) do
    campus = Entrances.get_campus!(id) 
    render(conn, "show.json-api", data: campus)
  end

  def update(conn, %{"id" => id, "campus" => campus_params}) do
    campus = Entrances.get_campus!(id)

    with {:ok, %Campus{} = campus} <- Entrances.update_campus(campus, campus_params) do
      render(conn, "show.json-api", data: campus)
    end
  end

  def delete(conn, %{"id" => id}) do
    campus = Entrances.get_campus!(id)

    with {:ok, %Campus{}} <- Entrances.delete_campus(campus) do
      send_resp(conn, :no_content, "")
    end
  end
end
