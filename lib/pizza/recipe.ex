defmodule Pizza.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pizza.{Ingredient, RecipeImage, Repo}

  @fields [:name, :slug, :description, :duration, :number_of_pizzas, :likes, :oven_type, :pizza_type, :steps]
  @required [:name, :description, :duration, :number_of_pizzas, :likes, :oven_type, :pizza_type, :steps]
  @ovens [:domestic, :pizza]
  @pizza_style [:neapolitan, :new_york, :american, :other]

  schema "recipe" do
    field(:name, :string)
    field(:slug, :string)
    field(:description, :string)
    field(:duration, :integer)
    field(:number_of_pizzas, :integer)
    field(:likes, :integer, default: 0)
    field(:oven_type, Ecto.Enum, values: @ovens)
    field(:pizza_type, :string)
    field(:video_url, :string)
    field(:steps, {:array, :string})

    has_many(:recipe_images, RecipeImage, on_delete: :delete_all)
    has_many(:ingredients, Ingredient, on_delete: :delete_all)

    # field(:author, :string)
    # field(:author_link, :string)

    timestamps()
  end

  @spec ovens :: [:domestic | :pizza]
  def ovens() do
    @ovens
  end

  def pizza_types() do
    @pizza_style
    # :new_york |> Atom.to_string |> String.split("_") |> Enum.map(&String.capitalize/1) |> Enum.join(" ")
  end

  def changeset(recipe, attrs \\ %{}) do
    recipe
    |> cast(attrs, @fields)
    |> cast_assoc(:ingredients, with: &Ingredient.changeset/2)
    |> validate_required(@required)
    |> generate_slug()
    |> validate_inclusion(:number_of_pizzas, 1..50)
    |> validate_inclusion(:duration, 1..200)
    |> validate_inclusion(:likes, 0..1_000)
    |> validate_inclusion(:oven_type, @ovens)
    |> validate_length(:steps, min: 1, max: 30)
    |> unique_constraint(:slug)
    |> validate_required(:slug)
  end

  @spec generate_slug(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp generate_slug(%Ecto.Changeset{errors: [{:name, _} | _]} = changeset), do: changeset

  defp generate_slug(%Ecto.Changeset{} = changeset) do
    {_, name} = fetch_field(changeset, :name)
    put_change(changeset, :slug, Slug.slugify(name))
  end

  def get_recipes() do
    Repo.all(Pizza.Recipe)
  end

  @spec get_recipe_by(map()) :: %Pizza.Recipe{} | nil
  def get_recipe_by(params) do
    Repo.get_by(Pizza.Recipe, params) |> Repo.preload(:recipe_images)
  end

  def create_recipe(attrs \\ %{}) do
    %Pizza.Recipe{}
    |> changeset(attrs)
    |> Repo.insert()
  end
end
