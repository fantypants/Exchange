defmodule Exchange.Repo.Migrations.CreateMoney do
  use Ecto.Migration

  def change do
    create table(:monies) do
      add :rate, :float
      add :date, :string
      add :currency, :string

      timestamps()
    end
  end
end
