defmodule Exchange.MoneyControllerTest do
  use ExchangeWeb.ConnCase

  alias Exchange.Models.Money
  @valid_attrs %{currency: "some currency", date: "some date", rate: 120.5}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end


  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, money_path(conn, :show, -1)
    end
  end

  test "latest shows correct view", %{conn: conn} do
    money = [%{date: "2018-10-10", currency: "USD", rate: 1.78, inserted_at: Timex.now(), updated_at: Timex.now()},%{date: "2018-10-10", currency: "AUD", rate: 1.87, inserted_at: Timex.now(), updated_at: Timex.now()}]
    Services.ExchangeParser.insert_into_database(money)
    money1 = %{date: "2018-10-10", currency: "USD", rate: 1.78}
    money2 = %{date: "2018-10-10", currency: "AUD", rate: 1.87}
    response =
      conn
      |> get(money_path(conn, :filter, "latest"))
      |> json_response(200)
    expected = %{
      "base" => "EUR", "date" => "2018-10-10", "rates" => [%{"AUD" => 1.87, "USD" => 1.78}]
    }
    assert response == expected
  end

  test "date shows correct view", %{conn: conn} do

    money = [%{date: "2018-10-10", currency: "USD", rate: 1.78, inserted_at: Timex.now(), updated_at: Timex.now()},%{date: "2018-10-10", currency: "AUD", rate: 1.87, inserted_at: Timex.now(), updated_at: Timex.now()}]
    Services.ExchangeParser.insert_into_database(money)
    money1 = %{date: "2018-10-10", currency: "USD", rate: 1.78}
    money2 = %{date: "2018-10-10", currency: "AUD", rate: 1.87}
    response =
      conn
      |> get(money_path(conn, :filter, "2018-10-10"))
      |> json_response(200)

    expected = %{
      "base" => "EUR", "date" => "2018-10-10", "rates" => [%{"AUD" => 1.87, "USD" => 1.78}]
    }

    assert response == expected
  end

  test "analyze shows correct view", %{conn: conn} do
    money = [%{date: "2018-10-10", currency: "USD", rate: 1.78, inserted_at: Timex.now(), updated_at: Timex.now()},%{date: "2018-10-10", currency: "AUD", rate: 1.87, inserted_at: Timex.now(), updated_at: Timex.now()}]
    Services.ExchangeParser.insert_into_database(money)
    money1 = %{date: "2018-10-10", currency: "USD", rate: 1.78}
    money2 = %{date: "2018-10-10", currency: "AUD", rate: 1.87}
    response =
      conn
      |> get(money_path(conn, :filter, "analyze"))
      |> json_response(200)

    expected = %{
      "base" => "EUR", "rates_analyze" => [%{"USD" => %{"avg" => 1.78, "max" => 1.78, "min" => 1.78}}, %{"AUD" => %{"avg" => 1.87, "max" => 1.87, "min" => 1.87}}]
    }
    assert response == expected
  end

end
