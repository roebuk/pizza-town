defmodule Pizza.RecipeImage do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Pizza.{Recipe, Repo}

  @fields [:description, :recipe_id, :filename]
  @required [:description, :recipe_id, :filename]
  @images_folder Application.get_env(:pizza, :images_folder)
  @image_details [{"small", "150"}, {"large", "980"}]

  schema "recipe_image" do
    field(:description, :string)
    field(:filename, :string)
    belongs_to(:recipe, Recipe)
    # field(:user, ??)

    timestamps()
  end

  def changeset(recipe_image, attrs \\ %{}) do
    recipe_image
    |> cast(attrs, @fields)
    |> validate_length(:description, min: 2, max: 100)
    |> put_change(:filename, Randomizer.randomizer(20))
    |> validate_required(@required)
  end

  # This needs some more work on the error handling case
  @spec create_image(map()) :: {:ok, Ecto.Changeset.t()} | {:error, Ecto.Changeset.t()}
  def create_image(attrs \\ %{}) do
    {_, inner} = Repo.transaction fn ->
      case %Pizza.RecipeImage{} |> changeset(attrs) |> Repo.insert() do
        {:ok, changeset} ->
          try do
            for {text, number} <- @image_details do
              Mogrify.open(attrs["image"].path)
                |> Mogrify.format("webp")
                |> Mogrify.quality(75)
                |> Mogrify.auto_orient()
                |> Mogrify.resize_to_fill("#{number}x#{number}")
                |> Mogrify.save(path: "#{@images_folder}/#{attrs["recipe_id"]}-#{changeset.filename}-#{text}.webp")
            end
            {:ok, changeset}
          rescue
            _ -> Repo.rollback({:error, changeset})
          end

        {:error, changeset} ->
          Repo.rollback({:error, changeset})
      end
    end
    inner
  end

  def get_images_for_recipe(id) do
    Repo.all(from ri in Pizza.RecipeImage, where: ri.recipe_id == ^id)
  end
end
