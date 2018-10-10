defmodule Exchange.Models.Money do
  use Ecto.Schema
  import Ecto.Changeset

  schema "monies" do
    field :rate, :float
    field :date, :string
    field :currency, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:rate, :date, :currency])
    |> validate_required([:rate, :date, :currency])
  end
end
