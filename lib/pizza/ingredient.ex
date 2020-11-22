defmodule Pizza.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pizza.{Recipe}

  @fields [:icon, :name]
  @icons [:water, :flour, :tomatoes, :salt, :yeast, :oil, :cheese, :leaves]

  schema "ingredient" do
    field(:icon, Ecto.Enum, values: @icons)
    field(:name, :string)
    field(:order, :integer)
    belongs_to(:recipe, Recipe)

    timestamps()
  end

  def icons(), do: @icons
  def changeset(recipe_image, attrs \\ %{}) do
    recipe_image
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_length(:name, min: 2, max: 50)
  end
end
