defmodule PizzaWeb.PageView do
  use PizzaWeb, :view


  def ovens() do
    Pizza.Recipe.ovens()
  end
end
