defmodule PizzaWeb.PageController do
  use PizzaWeb, :controller

  alias Pizza.{Recipe, RecipeImage}

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    recipes = Pizza.Recipe.get_recipes()

    render(conn, "index.html", recipes: recipes)
  end

  @spec detail(Plug.Conn.t(), any) :: Plug.Conn.t()
  def detail(conn, %{"slug" => slug}) do
    case Pizza.Recipe.get_recipe_by(%{slug: slug}) do
      nil ->
        conn
        |> Plug.Conn.put_status(:not_found)
        |> Phoenix.Controller.render(FireWeb.ErrorView, :"404")
        |> halt()

      recipe ->
        render(conn, "detail.html", recipe: recipe)
    end
  end

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = Recipe.changeset(%Recipe{})
    render(conn, "new.html", changeset: changeset)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"recipe" => recipe}) do
    case Pizza.Recipe.create_recipe(recipe) do
      {:ok, _} ->
        redirect(conn, to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  @spec upload(Plug.Conn.t(), map) :: Plug.Conn.t()
  def upload(conn, %{"recipe_id" => recipe_id}) do
    changeset = RecipeImage.changeset(%RecipeImage{})
    render(conn, "upload.html", changeset: changeset, recipe_id: recipe_id)
  end

  @spec process_upload(Plug.Conn.t(), map) :: Plug.Conn.t()
  def process_upload(conn, %{"recipe_image" => recipe_image}) do
    IO.inspect(RecipeImage.create_image(recipe_image))
    case RecipeImage.create_image(recipe_image) do
      {:ok, _} ->
        conn
          |> put_flash(:success, "File Uploaded")
          |> redirect(to: Routes.page_path(conn, :index))
      {:error, changeset} ->

        render(conn, "upload.html", changeset: changeset, recipe_id: recipe_image["recipe_id"])
    end
  end
end
