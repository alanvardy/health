defmodule HealthWeb.LayoutView do
  use HealthWeb, :view

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

  def tabs(opts \\ [], fun) when is_function(fun, 1) do
    nav_opts = [class: "nav nav-tabs", role: "tablist"] ++ opts
    div_opts = [class: "tab-content"]

    tabs = %{tabmode: :nav}
    nav_tag = content_tag(:ul, fun.(tabs), nav_opts)

    tabs = %{tabmode: :div}
    div_tag = content_tag(:div, fun.(tabs), div_opts)

    [nav_tag, div_tag]
  end

  def tab(f, label, opts \\ [], [do: _] = block) do
    id = label |> String.downcase |> String.replace(" ", "-")

    nav_class = if true do
      "nav-link"
    else
      "nav-link active"
    end

    div_class = if true do
      "tab-pane fade"
    else
      "tab-pane fade show active"
    end

    nav_opts = [class: nav_class, id: "#{id}-tab", role: "tab", href: "##{id}", "data-toggle": "tab", "aria-controls": id, "aria-selected": false]
    div_opts = [class: div_class, id: id, role: "tabpanel", "aria-labelledby": "#{id}-tab"]

    content = case f.tabmode do
      :nav -> content_tag(:li, content_tag(:a, label, nav_opts), class: "nav-item")
      :div -> content_tag(:div, div_opts, block)
    end

    content
  end

  # def tab(%{tabmode: :div}, label, opts \\ [], [do: _] = block) do
  #   id = label |> String.downcase |> String.replace(" ", "-")

  #   div_opts = [class: "tab-pane", id: id, role: "tabpanel", "aria-labelledby": "#{id}-tab"]

  #   content_tag(:div, div_opts, block)
  # end

  #<div class="tab-pane active" id="home" role="tabpanel" aria-labelledby="home-tab">...</div>

# <!-- Nav tabs -->
# <ul class="nav nav-tabs" id="myTab" role="tablist">
#   <li class="nav-item">
#     <a class="nav-link active" id="home-tab" data-toggle="tab" href="#home" role="tab" aria-controls="home" aria-selected="true">Home</a>
#   </li>
#   <li class="nav-item">
#     <a class="nav-link" id="profile-tab" data-toggle="tab" href="#profile" role="tab" aria-controls="profile" aria-selected="false">Profile</a>
#   </li>
#   <li class="nav-item">
#     <a class="nav-link" id="messages-tab" data-toggle="tab" href="#messages" role="tab" aria-controls="messages" aria-selected="false">Messages</a>
#   </li>
#   <li class="nav-item">
#     <a class="nav-link" id="settings-tab" data-toggle="tab" href="#settings" role="tab" aria-controls="settings" aria-selected="false">Settings</a>
#   </li>
# </ul>

  # def tabs(active: nil, unique: false, list: {}, content: {}, &block)
  #   raise 'expected a block' unless block_given?

  #   @_tab_mode = :tablist
  #   @_tab_active = (active || :first)
  #   @_tab_unique = ''.object_id if unique

  #   content_tag(:ul, {class: 'nav nav-tabs', role: 'tablist'}.merge(list)) do
  #     yield # Yield to tab the first time
  #   end +
  #   content_tag(:div, {class: 'tab-content'}.merge(content)) do
  #     @_tab_mode = :content
  #     @_tab_active = (active || :first)
  #     yield # Yield to tab the second time
  #   end
  # end

  # def tabs(opts \\ [], [do: _] = block) do
  #   IO.puts("---- TABS -----")

  #   nav_opts = [class: "nav nav-tabs", role: "tablist"] ++ opts
  #   div_opts = [class: "tab-content"]

  #   #block[:do] |> Tuple.append(:tabsmode)


  #   block = block ++ {:tabsmode}

  #   IO.inspect(block)

  #   nav_tag = content_tag(:ul, nav_opts, block)
  #   div_tag = content_tag(:div, div_opts, block)

  #   IO.puts("---- RET -----")

  #   [nav_tag, div_tag]
  # end

  # def tab(label, opts \\ [], [do: _] = block) do
  #   id = label |> String.downcase |> String.replace(" ", "-")

  #   IO.puts("---- TAB -----")

  #   nav_opts = [href: "#", class: "nav-link", id: "#{id}-tab", role: "tab", "data-toggle": "tab", "aria-controls": id, "aria-selected": false]

  #   IO.inspect(block)

  #   content_tag(:li, class: "nav-item") do
  #     content_tag(:a, label, nav_opts)
  #   end

  # end




















end
