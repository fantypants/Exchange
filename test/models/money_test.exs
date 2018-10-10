defmodule Exchange.MoneyTest do
  use Exchange.ModelCase

  alias Exchange.Money

  @valid_attrs %{currency: "some currency", date: "some date", rate: 120.5}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Money.changeset(%Money{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Money.changeset(%Money{}, @invalid_attrs)
    refute changeset.valid?
  end
end
