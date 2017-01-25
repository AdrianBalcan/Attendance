defmodule Attendance.DayViewController do
  use Attendance.Web, :controller

  plug Attendance.Plug.Authenticate
  alias Attendance.DayView

  def index(conn, _params) do
    current_user_id = get_session(conn, :current_user).id

    querry = from(a in Attendance.Attendance,
      right_join: day in fragment("select generate_series('2017-01-01'::timestamp, current_date, '1 day')::date AS d"),
      on: day.d == fragment("date(?)", a.inserted_at),
      group_by: day.d,
      order_by: [desc: day.d],
      select: [ 
       # day: fragment("date(?)", day.d),
        day.d, 
        fragment("(SELECT id from attendances where date(inserted_at) = ?)", day.d)
      ]
    )

    query =
      Attendance.Attendance
      |> join(:right, [a], day in fragment("select generate_series('2017-01-01'::timestamp, current_date, '1 day')::date AS d"),
        day.d == fragment("date(?)", a.inserted_at))
      |> join(:inner_lateral, [a, day], e in fragment("SELECT * FROM attendances AS e"), day.d == fragment("date(?)", e.inserted_at))
      |> group_by([a,day,e], day.d)
      |> select([a, day, e], %{day: day.d, employees: %{employeeID: e.employeeID}})
   #   |> join(:inner_lateral, [g], gs in fragment("SELECT * FROM games_sold AS gs WHERE gs.game_id = ? ORDER BY gs.sold_ON LIMIT 2", g.id))
      #|> select([g, gs], {g.name, gs.sold_on})

#SELECT f1."d", f2."employeeID" FROM "attendances" AS a0 RIGHT OUTER JOIN (select generate_series('2017-01-01'::timestamp, current_date, '1 day')::date AS d) AS f1 ON f1."d" = date(a0."inserted_at") INNER JOIN LATERAL (SELECT * FROM attendances AS e WHERE date(e.inserted_at) = f1."d") AS f2 ON TRUE []
    sql = """
        SELECT day."d"
        FROM (select generate_series('2017-01-01'::timestamp, current_date, '1 day')::date AS d) AS day
    """

#    sql = """
#        SELECT day."d", array_agg(e)
#        FROM (select generate_series('2017-01-01'::timestamp, current_date, '1 day')::date AS d) AS day
#        LEFT JOIN LATERAL (SELECT e."employeeID", array_agg(s) FROM "attendances" AS e
#          LEFT JOIN LATERAL(SELECT s."status", s."inserted_at" from "attendances" AS s 
#            WHERE date(s."inserted_at") = day."d" and s."employeeID" = e."employeeID" GROUP BY s."inserted_at",s."status") AS s ON true
#        WHERE date(e."inserted_at") = day."d" GROUP BY e."employeeID") AS e
#        ON true
#        GROUP BY day."d"
#        ORDER BY day.d DESC
#
#      """

    #results = Repo.all(query) 
    day_views = Ecto.Adapters.SQL.query!(Repo, sql, [])
    #IO.inspect results
   # day_views = for days <- results do
   #   days.day 
   # end
    #day_views = Enum.uniq(results)
    #IO.inspect day_views
   
    defmodule EmployeesQuery do 
      def employees(date) do
       IO.inspect date
       {"test"}
      end
    end

  #  day_views = for days <- day_views do
  #    %{day: Ecto.Date.from_erl(days.day),
  #      employees: [
  #    EmployeesQuery.employees(Ecto.date.from_erl(days.day))]}
  #  end
  #  IO.inspect day_views
    day_views = for days <- day_views do
       IO.inspect days
   #   %{day: Ecto.Date.from_erl(days.day),
   #     employees: [
   #   %{employeeID: "8", status: [%{status: "IN", inserted_at: "09:20"}]}]}
    end
    #IO.inspect day_views

    render(conn, "index.html")
  end

#  def new(conn, _params) do
#    changeset = DayView.changeset(%DayView{})
#    render(conn, "new.html", changeset: changeset)
#  end
#
#  def create(conn, %{"day_view" => day_view_params}) do
#    changeset = DayView.changeset(%DayView{}, day_view_params)
#
#    case Repo.insert(changeset) do
#      {:ok, _day_view} ->
#        conn
#        |> put_flash(:info, "Day view created successfully.")
#        |> redirect(to: day_view_path(conn, :index))
#      {:error, changeset} ->
#        render(conn, "new.html", changeset: changeset)
#    end
#  end
#
#  def show(conn, %{"id" => id}) do
#    day_view = Repo.get!(DayView, id)
#    render(conn, "show.html", day_view: day_view)
#  end
#
#  def edit(conn, %{"id" => id}) do
#    day_view = Repo.get!(DayView, id)
#    changeset = DayView.changeset(day_view)
#    render(conn, "edit.html", day_view: day_view, changeset: changeset)
#  end
#
#  def update(conn, %{"id" => id, "day_view" => day_view_params}) do
#    day_view = Repo.get!(DayView, id)
#    changeset = DayView.changeset(day_view, day_view_params)
#
#    case Repo.update(changeset) do
#      {:ok, day_view} ->
#        conn
#        |> put_flash(:info, "Day view updated successfully.")
#        |> redirect(to: day_view_path(conn, :show, day_view))
#      {:error, changeset} ->
#        render(conn, "edit.html", day_view: day_view, changeset: changeset)
#    end
#  end
#
#  def delete(conn, %{"id" => id}) do
#    day_view = Repo.get!(DayView, id)
#
#    # Here we use delete! (with a bang) because we expect
#    # it to always work (and if it does not, it will raise).
#    Repo.delete!(day_view)
#
#    conn
#    |> put_flash(:info, "Day view deleted successfully.")
#    |> redirect(to: day_view_path(conn, :index))
#  end
end
