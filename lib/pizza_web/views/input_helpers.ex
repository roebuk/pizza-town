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

    content_tag :li, class: "step-item" do
      [
        content_tag :div, class: "step-item-head" do
          [
            label(form, "Step", class: "form-element-label"),
            link("Remove", to: "#", data: data, title: "remove", type: "button", class: "step-remove js-remove-step")
          ]
        end,
        apply(Form, :textarea, [form, field, opts])
      ]
    end
  end


  def sample(form, x) do
    # IO.inspect(form)
    # IO.inspect(x)

    label(x, :name, class: "control-label")
    text_input(x, :name, class: "form-element-input")

    content_tag :li, class: "oi-oi" do
      [
        # for {val, _idx} <- Enum.with_index(values) do
        #   content_tag :li, class: "oi-oi" do
        #   [
        #     label(form, val.icon, class: "form-element-label"),
        #     text_input(form, :name, class: "form-element-input")
        #   ]
        # end
        # end

    #     text_input()
    #     text_input(form, :number_of_pizzas,
    #         field(:icon, Ecto.Enum, values: @icons)
    # field(:name, :string)
      ]
    end
  end
end
