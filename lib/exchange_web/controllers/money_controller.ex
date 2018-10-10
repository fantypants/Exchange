defmodule ExchangeWeb.MoneyController do
  use ExchangeWeb, :controller
  import Ecto.Query

  alias Exchange.Models.Money
  alias Exchange.Repo

  def index(conn, _params) do
    monies = Repo.all(Money)
    render(conn, "index.json", monies: monies)
  end
  def filter(conn, %{"type" => type}) when type == "latest", do: latest(conn)
  def filter(conn, %{"type" => type}) when type == "analyze", do: analyze(conn)

  defp format_money(money) do
    money |> Enum.group_by(fn x -> x.date end)
  end

  def latest(conn) do
    query = from m in Money, select: m.date
    date = Repo.all(query) |> Enum.max
    monies = format_money(Repo.all(from m in Money, where: m.date == ^date, order_by: m.currency))
    render(conn, "latest.json", date: date, monies: monies)
  end

  def filter(conn, %{"type" => type}) do
    query = from m in Money, where: m.date == ^type, order_by: m.currency
    monies = Repo.all(query)
      |> format_money
    render(conn, "filtered.json", monies: monies)
  end

  defp find_avg(currency) do
    query = from m in Money, where: m.currency == ^currency, select: m.rate
    data = Repo.all(query)
    size = Enum.count(data)
    avg = Enum.sum(data)/size
    min = Enum.min(data)
    max = Enum.max(data)
    %{currency: currency, avg: avg, min: min, max: max}
  end

  def analyze(conn) do
    query = from m in Money, select: m.currency
    currency = Repo.all(query) |> Enum.uniq
    monies = Enum.map(currency, fn label -> find_avg(label) end)
    render(conn, "analyze.json", monies: monies)
  end

  def insert_single(params) do
    money_params = %{"date" => params.date, "currency" => params.currency, "rate" => params.rate}
    changeset = Money.changeset(%Money{}, money_params)
    Repo.insert_or_update(changeset)
  end

  def create(conn, %{"money" => money_params}) do
    changeset = Money.changeset(%Money{}, money_params)

    case Repo.insert(changeset) do
      {:ok, money} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", money_path(conn, :show, money))
        |> render("show.json", money: money)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Exchange.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    money = Repo.get!(Money, id)
    render(conn, "show.json", money: money)
  end

  def update(conn, %{"id" => id, "money" => money_params}) do
    money = Repo.get!(Money, id)
    changeset = Money.changeset(money, money_params)

    case Repo.update(changeset) do
      {:ok, money} ->
        render(conn, "show.json", money: money)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Exchange.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    money = Repo.get!(Money, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(money)

    send_resp(conn, :no_content, "")
  end
end
