defmodule HealthWeb.BootstrapHelper do
  @moduledoc """
  Boostrap 4 view helpers
  """

  import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]
  use Phoenix.HTML

  # Bootstrap4 - Flash Alert
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
  @spec nav_link(Plug.Conn.t(), String.t(), Keyword.t()) :: Phoenix.HTML.safe()
  def nav_link(%{request_path: request_path}, text, opts) do
    # Apply nav-item and active to the li tag
    nav_class =
      case request_path == opts[:to] do
        true -> ['nav-item', 'active']
        false -> ['nav-item']
      end
      |> Enum.join(" ")

    # Apply nav-item to the a tag
    opts =
      case Keyword.get(opts, :class) do
        nil -> Keyword.put(opts, :class, "nav-link")
        other -> Keyword.put(opts, :class, "nav-link #{other}")
      end

    content_tag(:li, link(text, opts), class: nav_class)
  end

  # Bootstrap4 - Tabs
  # Helper for quickly creating Bootstrap4 tabs
  #
  # <%= tabs(active: "Two") do %>
  #   <%= tab("One") do %>
  #     <p>This is tab one</p>
  #   <% end %>

  #   <%= tab("Two") do %>
  #     <p>This is tab two</p>
  #   <% end %>
  # <% end %>
  #
  @spec tabs(Keyword.t(), Phoenix.HTML.safe()) :: Phoenix.HTML.safe()
  def tabs(opts \\ [active: :first, class: ""], do: {:safe, tabs_content}) do
    # Either :first, or a String matching the tab label
    active = Keyword.get(opts, :active, :first)
    navclass = String.trim("nav nav-tabs #{Keyword.get(opts, :class, "")}")

    nav_opts = [class: navclass, role: "tablist"] ++ Keyword.drop(opts, [:class, :active])
    div_opts = [class: "tab-content"]

    content = tabs_content |> Enum.to_list() |> Enum.filter(fn x -> is_list(x) end)
    index = tabs_find_index(content, active) || 0

    navs = content |> tabs_get_navs |> tabs_activate_navs(index) |> raw
    divs = content |> tabs_get_divs |> tabs_activate_divs(index) |> raw

    nav_tag = content_tag(:ul, navs, nav_opts) |> safe_to_string
    div_tag = content_tag(:div, divs, div_opts) |> safe_to_string

    {:safe, nav_tag <> div_tag}
  end

  # Bootstrap4 - Tab
  # Works with tabs helper
  @spec tab(String.t(), Keyword.t(), Phoenix.HTML.safe()) :: Phoenix.HTML.safe()
  def tab(label, opts \\ [], [do: _] = block) do
    id = label |> String.downcase() |> String.replace(" ", "-")
    controls = Kernel.to_charlist(id) |> Enum.sum()

    nav_opts = [
      class: "nav-link",
      id: "tab-#{id}-#{controls}",
      role: "tab",
      href: "##{id}-#{controls}",
      "data-toggle": "tab",
      "aria-controls": "#{id}-#{controls}",
      "aria-selected": false
    ]

    div_opts = [
      class: "tab-pane fade",
      id: "#{id}-#{controls}",
      role: "tabpanel",
      "aria-labelledby": "tab-#{id}-#{controls}"
    ]

    nav_tag = content_tag(:li, content_tag(:a, label, nav_opts), class: "nav-item")
    div_tag = content_tag(:div, div_opts, block)

    [nav_tag, div_tag]
  end

  defp tabs_get_navs(list), do: list |> Enum.map(&List.first/1)
  defp tabs_get_divs(list), do: list |> Enum.map(&List.last/1)

  defp tabs_find_index(list, active) when active == :first, do: 0

  defp tabs_find_index(list, active) do
    list
    |> tabs_get_navs
    |> Enum.find_index(fn x -> x |> List.flatten() |> Enum.member?(active) end)
  end

  defp tabs_activate_navs(list, index), do: list |> List.update_at(index, &tabs_activate_nav/1)
  defp tabs_activate_divs(list, index), do: list |> List.update_at(index, &tabs_activate_div/1)

  defp tabs_activate_nav(tags) do
    tags |> to_string |> String.replace("nav-link", "nav-link active", global: false)
  end

  defp tabs_activate_div(tags) do
    tags |> to_string |> String.replace("tab-pane", "tab-pane show active", global: false)
  end
end
