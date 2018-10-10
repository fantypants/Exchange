defmodule ExchangeWeb.MoneyView do
  use ExchangeWeb, :view

  def render("index.json", %{monies: monies}) do
    %{data: render_many(monies, ExchangeWeb.MoneyView, "money.json")}
  end

  def render("analyze.json", %{monies: monies}) do
    %{base: "EUR", rates_analyze: render_many(monies, ExchangeWeb.MoneyView, "analyzed.json")}
  end

  def render("latest.json", %{date: date, monies: monies}) do
    %{
      date: "#{date}", base: "EUR", rates: Enum.map(monies, &monies_json2/1)
    }
  end
  def render("filtered.json", %{monies: monies}) do
    %{base: "EUR", date: "#{Map.keys(monies)}", rates: Enum.map(monies, &monies_json2/1), base: "EUR"
    }
  end

  def monies_json2(money) do
  {date, list} = money
  list |> List.flatten |> Enum.reduce(%{}, fn map, acc -> Map.put(acc, map.currency, map.rate) end) #|> List.flatten #|> Enum.map(&monies_json/1)
  end

  def monies_json(money) do
    %{
      "#{money.currency}": "#{money.rate}",
    }
  end

  def render("show.json", %{money: money}) do
    %{data: render_one(money, ExchangeWeb.MoneyView, "money.json")}
  end

  def render("money.json", %{money: money}) do

    %{"#{money.date}": %{
      "#{money.currency}": money.rate}}
  end
  def render("analyzed.json", %{money: money}) do
    %{"#{money.currency}":  %{
      avg: money.avg,
      max: money.max,
      min: money.min}}
  end
end
