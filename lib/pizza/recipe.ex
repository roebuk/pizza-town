defmodule Pizza.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pizza.{Repo}

  @fields [:name, :slug, :description, :duration, :number_of_pizzas, :likes, :oven_type, :steps]
  @required [:name, :description, :duration, :number_of_pizzas, :likes, :oven_type, :steps]
  @ovens [:domestic, :pizza]

  schema "recipe" do
    field(:name, :string)
    field(:slug, :string)
    field(:description, :string)
    field(:duration, :integer)
    field(:number_of_pizzas, :integer)
    field(:likes, :integer, default: 0)
    field(:oven_type, Ecto.Enum, values: @ovens)
    field(:steps, {:array, :string})
    # field(:author, ??)

    timestamps()
  end

  @spec ovens :: [:domestic | :pizza]
  def ovens() do
    @ovens
  end

  def changeset(recipe, attrs \\ %{}) do
    recipe
    |> cast(attrs, @fields)
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

  @spec create_recipe(:invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}) ::
          any
  def create_recipe(attrs \\ %{}) do
    %Pizza.Recipe{}
    |> changeset(attrs)
    |> Repo.insert()
  end
end
