defmodule PizzaWeb.InputHelpers do
  use Phoenix.HTML

  alias Phoenix.HTML.{Form}


  def array_input(form, field) do
    id = Form.input_id(form, field) <> "_container"
    values = Form.input_value(form, field) || [""]

    content_tag :ol, id: id, class: "input_container" do
      for {value, idx} <- Enum.with_index(values) do

        input_opts = [
          value: value,
          id: nil
        ]
        create_li(form, field, input_opts, [index: idx])
      end
    end

  end

  def create_li(form, field, input_options \\ [], data \\ []) do
    name = Form.input_name(form, field) <> "[]"
    opts = Keyword.merge(input_options, [{:class, "form-element-textarea"}, {:name, name}])

    content_tag :li do
      [
        label(form, "Step"),
        apply(Form, :textarea, [form, field, opts]),
        link("Remove", to: "#", data: data, title: "remove", type: "button", class: "js-remove-step")
      ]
    end
  end

end
