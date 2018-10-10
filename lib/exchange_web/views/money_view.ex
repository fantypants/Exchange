defmodule ExchangeWeb.MoneyView do
  use ExchangeWeb, :view

  def render("index.json", %{monies: monies}) do
    %{data: render_many(monies, ExchangeWeb.MoneyView, "money.json")}
  end

  def render("latest.json", %{monies: monies}) do
    grouped = monies |> Enum.group_by(fn x -> x.date end) |> IO.inspect
    %{data: render_many(monies, ExchangeWeb.MoneyView, "money.json")}
  end

  def render("filtered.json", %{monies: monies}) do
    %{data: render_many(monies, ExchangeWeb.MoneyView, "money.json")}
  end

  def render("analyze.json", %{monies: monies}) do
    %{data: render_many(monies, ExchangeWeb.MoneyView, "analyzed.json")}
  end

  def render("show.json", %{money: money}) do
    %{data: render_one(money, ExchangeWeb.MoneyView, "money.json")}
  end

  def render("money.json", %{money: money}) do


    %{"#{money.date}": %{
      "#{money.currency}": money.rate}}
  end
  def render("analyzed.json", %{money: money}) do
    %{base: "EUR", rates_analyze: %{"#{money.currency}":  %{
      avg: money.avg,
      max: money.max,
      min: money.min}}}
  end
end
