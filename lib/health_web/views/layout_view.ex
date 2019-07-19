defmodule HealthWeb.LayoutView do
  use HealthWeb, :view
  import Health.Account.Roles

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

    {:ok, pid} = Agent.start_link(fn -> %{tabmode: :nav, activate: activate, controls: :erlang.unique_integer([:positive])} end)
    nav_tag = content_tag(:ul, fun.(pid), nav_opts)

    :ok = Agent.update(pid, fn map -> Map.merge(map, %{tabmode: :div, activate: activate}) end)
    div_tag = content_tag(:div, fun.(pid), div_opts)

    Agent.stop(pid)

    [nav_tag, div_tag]
  end

  def tab(pid, label, opts \\ [], [do: _] = block) do
    id = label |> String.downcase |> String.replace(" ", "-")

    tabmode = Agent.get(pid, fn map -> Map.get(map, :tabmode) end)
    activate = Agent.get(pid, fn map -> Map.get(map, :activate) end)
    controls = Agent.get(pid, fn map -> Map.get(map, :controls) end)

    active = (activate == :first || activate == label)

    if active do
      Agent.update(pid, fn map -> Map.put(map, :activate, label) end)
    end

    nav_class = (unless active, do: "nav-link", else: "nav-link active")
    div_class = (unless active, do: "tab-pane fade", else: "tab-pane fade show active")

    nav_opts = [class: nav_class, id: "tab-#{id}-#{controls}", role: "tab", href: "##{id}-#{controls}", "data-toggle": "tab", "aria-controls": "#{id}-#{controls}", "aria-selected": false]
    div_opts = [class: div_class, id: "#{id}-#{controls}", role: "tabpanel", "aria-labelledby": "tab-#{id}-#{controls}"]

    case tabmode do
      :nav -> content_tag(:li, content_tag(:a, label, nav_opts), class: "nav-item")
      :div -> content_tag(:div, div_opts, block)
    end
  end

end
