defmodule HealthWeb.BootstrapHelper do
  #use HealthWeb, :view
  #use Phoenix.HTML

  import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]
  use Phoenix.HTML

  # Change alert-error to alert-danger
  @spec bootstrap_flash(%{private: map}) :: map()
  def bootstrap_flash(conn) do
    conn
    |> get_flash
    |> Enum.map(&bootstrap_flash_convert/1)
  end

  defp bootstrap_flash_convert(classes) do
    case classes do
      {"error", message} -> {"danger", message}
      _ -> classes
    end
  end

  # Bootstrap4 - Nav Link
  # Automatically puts in the 'active' class when on conn.request_path
  # <%= nav_link(@conn, "Home", to: "/") %>
  @spec nav_link(Plug.Conn.t(), String.t(), Keyword.t()) :: String.t()
  def nav_link(%{request_path: request_path}, text, opts) do
    # Apply nav-item and active to the li tag
    nav_class = case request_path == opts[:to] do
      true -> ['nav-item', 'active']
      false -> ['nav-item']
    end |> Enum.join(" ")

    # Apply nav-item to the a tag
    opts = case Keyword.get(opts, :class) do
      nil -> Keyword.put(opts, :class, "nav-link")
      other -> Keyword.put(opts, :class, "nav-link #{other}")
    end

    content_tag(:li, link(text, opts), class: nav_class)
  end

  def tabs(opts \\ [activate: :first, class: ""], fun) when is_function(fun, 1) do
    activate = Keyword.get(opts, :activate, :first) # Either :first, or a String matching the tab label
    navclass = String.trim("nav nav-tabs #{Keyword.get(opts, :class, "")}")

    nav_opts = [class: navclass, role: "tablist"] ++ Keyword.drop(opts, [:class, :activate])
    div_opts = [class: "tab-content"]

    content = fun.(nil) |> elem(1) |> Enum.to_list |> Enum.filter(fn x -> is_list(x) end)

    nav_content = content
      |> Enum.map(fn x -> tab_content(x) end)
      |> List.update_at(0, fn x -> tab_activate(x) end)

    div_content = content
      |> Enum.map(fn x -> div_content(x) end)
      |> List.update_at(0, fn x -> div_activate(x) end)

    nav_tag = content_tag(:ul, raw(nav_content), nav_opts)
    div_tag = content_tag(:div, raw(div_content), div_opts)

    [nav_tag, div_tag]
  end

  def tab_content(tags) when is_list(tags), do: tags |> List.first
  def tab_content(tags), do: nil

  def tab_activate(tags) do
    tags |> raw |> safe_to_string |> String.replace("nav-link", "nav-link active")
  end

  def div_activate(tags) do
    tags |> raw |> safe_to_string |> String.replace("tab-pane", "tab-pane show active")
  end

  def div_content(tags) when is_list(tags), do: tags |> List.last
  def div_content(tags), do: nil

  def tab(label, opts \\ [], [do: _] = block) do
    id = label |> String.downcase |> String.replace(" ", "-")
    controls = Kernel.to_charlist(id) |> Enum.sum

    nav_opts = [class: "nav-link", id: "tab-#{id}-#{controls}", role: "tab", href: "##{id}-#{controls}", "data-toggle": "tab", "aria-controls": "#{id}-#{controls}", "aria-selected": false]
    div_opts = [class: "tab-pane fade", id: "#{id}-#{controls}", role: "tabpanel", "aria-labelledby": "tab-#{id}-#{controls}"]

    nav_tag = content_tag(:li, content_tag(:a, label, nav_opts), class: "nav-item")
    div_tag = content_tag(:div, div_opts, block)

    [nav_tag, div_tag]
  end

end
