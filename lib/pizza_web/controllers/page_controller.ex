defmodule PizzaWeb.PageController do
  use PizzaWeb, :controller

  alias Pizza.{Recipe}

  @recipes [
    %{
      name: "Neapolitan - 100% Biga",
      slug: "100-biga",
      votes: 15,
      short_description: "A simple recipe with fantastic results. Super light and ariy crusts!",
      description: "A simple recipe with fantastic results. Super light and airy crusts! Make the Biga before you go to bed and your pizza will be ready for lunch."
    }
  ]

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    recipes = Pizza.Recipe.get_recipes()

    render(conn, "index.html", recipes: recipes)
  end

  @spec detail(Plug.Conn.t(), any) :: Plug.Conn.t()
  def detail(conn, _params) do
    render(conn, "detail.html", recipe: Enum.at(@recipes, 0))
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
end
