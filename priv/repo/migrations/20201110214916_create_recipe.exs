defmodule Pizza.Repo.Migrations.CreateRecipe do
  use Ecto.Migration

  def change do
    create table(:recipe) do
      add(:name, :string)
      add(:description, :string)
      add(:slug, :string)
      add(:duration, :integer)
      add(:number_of_pizzas, :integer)
      add(:oven_type, :string)

      timestamps()
    end

    create(index(:recipe, [:slug]))
  end
end
