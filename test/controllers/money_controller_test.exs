defmodule Exchange.MoneyControllerTest do
  use Exchange.ConnCase

  alias Exchange.Money
  @valid_attrs %{currency: "some currency", date: "some date", rate: 120.5}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, money_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    money = Repo.insert! %Money{}
    conn = get conn, money_path(conn, :show, money)
    assert json_response(conn, 200)["data"] == %{"id" => money.id,
      "rate" => money.rate,
      "date" => money.date,
      "currency" => money.currency}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, money_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, money_path(conn, :create), money: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Money, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, money_path(conn, :create), money: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    money = Repo.insert! %Money{}
    conn = put conn, money_path(conn, :update, money), money: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Money, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    money = Repo.insert! %Money{}
    conn = put conn, money_path(conn, :update, money), money: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    money = Repo.insert! %Money{}
    conn = delete conn, money_path(conn, :delete, money)
    assert response(conn, 204)
    refute Repo.get(Money, money.id)
  end
end
