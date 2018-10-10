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

  test "#show renders a latest todo" do
    conn = build_conn()

    conn = get conn, money_path(conn, :filter, money)


  end

end
