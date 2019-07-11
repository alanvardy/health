defmodule HealthWeb.LayoutView do
  use HealthWeb, :view

  # Change alert-error to alert-danger
  def bootstrap_flash(conn) do
    Enum.map(get_flash(conn), fn { key, message} ->
      case key do
        "error" -> { "danger", message }
        _ -> { key, message }
      end
    end
   )
  end
end
