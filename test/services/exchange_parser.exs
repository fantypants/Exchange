defmodule Exchange.Services.ExchangeParserTest do
  use ExchangeWeb.ConnCase
  alias Services.ExchangeParser
  alias ExchangeWeb.PageController
  import Plug.Conn

  test "Module loads correctly" do
    assert ExchangeParser.init == :ok
  end

  test "URL response is verified" do
    assert ExchangeParser.get_response == :ok
  end

  test "URL is correctly parsed" do
    {status, data} = ExchangeParser.get_xml
    assert status == :ok
  end

  test "Data is correctly inserted" do
    {status, data} = ExchangeParser.get_xml
    ExchangeParser.insert_into_database(data)
    rates = ExchangeParser.get_rates
    #assert is_int(rates) == true
  end

  #test "GET Filtered Data /", %{conn: conn} do
  #  conn = get conn, "/2018-10-05"
  #  assert html_response(conn, 200) =~ "DATE CURRENCY RATE"
  #end

end
