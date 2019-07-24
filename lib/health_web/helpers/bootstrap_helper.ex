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

  def tabs(opts \\ [activate: :first, class: ""], [do: block]) do
    activate = Keyword.get(opts, :activate, :first) # Either :first, or a String matching the tab label
    navclass = String.trim("nav nav-tabs #{Keyword.get(opts, :class, "")}")

    nav_opts = [class: navclass, role: "tablist"] ++ Keyword.drop(opts, [:class, :activate])
    div_opts = [class: "tab-content"]

    content = block |> elem(1) |> Enum.to_list |> Enum.filter(fn x -> is_list(x) end)

    navs = content |> get_tab_navs
    divs = content |> get_tab_divs

    index = navs |> get_active_index(activate)

    nav_tag = content_tag(:ul, navs |> activate_tab_navs(index) |> raw, nav_opts)
    div_tag = content_tag(:div, divs |> activate_tab_divs(index) |> raw, div_opts)

    [nav_tag, div_tag]
  end

  defp get_tab_navs(list), do: list |> Enum.map(fn x -> x |> List.first end)
  defp get_tab_divs(list), do: list |> Enum.map(fn x -> x |> List.last end)

  defp get_active_index(list, activate) when activate == :first, do: 0
  defp get_active_index(list, activate) do
    Enum.find_index(list, fn x -> x |> List.flatten |> Enum.member?(activate) end)
  end

  defp activate_tab_navs(list, index), do: List.update_at(list, index, fn x -> tab_activate(x) end)
  defp activate_tab_divs(list, index), do: List.update_at(list, index, fn x -> div_activate(x) end)

  defp tab_activate(tags) do
    tags |> raw |> safe_to_string |> String.replace("nav-link", "nav-link active")
  end

  defp div_activate(tags) do
    tags |> raw |> safe_to_string |> String.replace("tab-pane", "tab-pane show active")
  end

  # defp activate_tab_navs([head|tail], activate) when activate == :first, do: [tab_activate(head)|tail]
  # defp activate_tab_divs([head|tail], activate) when activate == :first, do: [div_activate(head)|tail]


  # defp activate_tab_divs(list, activate) do
  #   # index = Enum.find_index(list, fn x -> x |> IO.inspect |> String.contains("role=\"tab\">#{activate}</a>"))
  #   # list |> List.update_at(index, fn x -> tab_activate(tags))
  #   list
  # end

  # def tab_content(tags) when is_list(tags), do: tags |> List.first

  # def div_content(tags) when is_list(tags), do: tags |> List.last
  # def div_content(tags), do: nil

  # def tab_index(tags, label) when label == :first, do: 0
  # def tab_index(tags, label) do
  #   1
  # end




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
