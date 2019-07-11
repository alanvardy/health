defmodule HealthWeb.LayoutView do
  use HealthWeb, :view

  # Change alert-error to alert-danger
  def bootstrap_flash(conn) do
    Enum.map(get_flash(conn), fn
      {"error", message} -> {"danger", message}
      other -> other
    end)
  end
end
