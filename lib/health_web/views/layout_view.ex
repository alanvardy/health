defmodule HealthWeb.LayoutView do
  use HealthWeb, :view
  import Health.Account.Role

  # Change alert-error to alert-danger
  @spec bootstrap_flash(atom | %{private: map}) :: [any]
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
  @spec nav_link(%{request_path: any}, any, keyword) :: {:safe, [...]}
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
end
