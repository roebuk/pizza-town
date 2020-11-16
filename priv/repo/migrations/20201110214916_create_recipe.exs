defmodule Pizza.Repo.Migrations.CreateRecipe do
  use Ecto.Migration

  def change do
    create table(:recipe) do
      add(:name, :string, null: false)
      add(:description, :text, null: false)
      add(:slug, :string, null: false)
      add(:duration, :integer, null: false)
      add(:number_of_pizzas, :integer, null: false)
      add(:likes, :integer, null: false, default: 0)
      add(:oven_type, :string, null: false)
      add(:steps, {:array, :text}, null: false, default: [])

      timestamps()
    end

    create table(:recipe_image) do
      add(:description, :string, null: false)
      add(:filename, :string, null: false)
      add(:recipe_id, references(:recipe), null: false)

      timestamps()
    end

    create(unique_index(:recipe, [:slug]))
    create(index(:recipe_image, [:recipe_id]))
  end
end
