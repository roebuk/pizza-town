defmodule PizzaWeb.PageView do
  use PizzaWeb, :view
  #  <div class="spotlight-group" data-title="<%= @recipe.name %>" data-autofit="false" data-zoom="false" data-fullscreen="false" data-theme="false" data-maximize="false" data-minimize="false">
  #   <a class="spotlight" href="<%= Routes.static_path(@conn, "/images/1.jpg") %>" data-description="Pizza">
  #     <img class="image-preview" src="<%= Routes.static_path(@conn, "/images/1.jpg") %>" alt="pizza" loading="lazy">
  #   </a>
  #   <a class="spotlight" href="<%= Routes.static_path(@conn, "/images/2.jpg") %>" data-description="The crust">
  #     <img class="image-preview" src="<%= Routes.static_path(@conn, "/images/2.jpg") %>" alt="The crust" loading="lazy">
  #   </a>

  #   <a href="<%= Routes.page_path(@conn, :upload, @recipe.id) %>">Upload</a>
  # </div>

  def render_image(_conn, recipe_id, image) do
    image_url_large =  "/media/" <> Integer.to_string(recipe_id) <> "-" <> image.filename <> "-small.webp"
    image_url_small =  "/media/" <> Integer.to_string(recipe_id) <> "-" <> image.filename <> "-small.webp"

    content_tag :a, class: "spotlight", href: image_url_large, data: [description: image.description]  do
      [
       content_tag :img, class: "image-preview", src: image_url_small, alt: image.description, loading: "lazy" do
        []
       end
      ]
    end
  end

  def render_recipe_images(conn, recipe) do
    content_tag :div, class: "spotlight-group" do
          [
            for image <- recipe.recipe_images do
              render_image(conn, recipe.id, image)
            end,
            link("Upload", to: Routes.page_path(conn, :upload, recipe.id))
          ]
    end
  end

  def ovens() do
    Pizza.Recipe.ovens()
  end
end
