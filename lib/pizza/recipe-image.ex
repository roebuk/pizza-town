defmodule Pizza.RecipeImage do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pizza.{Repo}

  @fields [:name, :filename]
  @required [:name, :filename]
  @small "small"
  @large "large"

  schema "recipe_image" do
    field(:name, :string)
    field(:filename, :string)

    # field(:related_to_recipe, ??)
    # field(:user, ??)

    timestamps()
  end


  def changeset(recipe, attrs \\ %{}) do
    recipe
    |> cast(attrs, @fields)
    |> validate_required(@required)
  end


  def get_recipes() do
    Repo.all(Pizza.Recipe)
  end
end
