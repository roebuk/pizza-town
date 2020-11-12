defmodule PizzaWeb.InputHelpers do
  use Phoenix.HTML

  alias Phoenix.HTML.{Form}

  def create_li(form, field, input_options \\ [], data \\ []) do
    type = Form.input_type(form, field)
    name = Form.input_name(form, field) <> "[]"
    opts = Keyword.put_new(input_options, :name, name)

    content_tag :li do
      [
        apply(Form, type, [form, field, opts]),
        button("Remove", to: "#", data: data, title: "remove")
      ]
    end
  end

end
