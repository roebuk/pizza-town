defmodule Pizza.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pizza.{Repo}

  @fields [:name, :slug, :description]
  @required [:name, :description]

  schema "recipe" do
    field(:name, :string)
    field(:slug, :string)
    field(:description, :string)

    timestamps()
  end

  def changeset(recipe, attrs \\ %{} ) do
    recipe
    |> cast(attrs, @fields)
    |> validate_required(@required)
    |> generate_slug()
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

  def create_recipe(attrs \\ %{}) do
    %Pizza.Recipe{}
    |> changeset(attrs)
    |> Repo.insert()
  end
end
