defmodule HealthWeb.LayoutView do
  use HealthWeb, :view

  # Change alert-error to alert-danger
  def bootstrap_flash(conn) do
    conn
    |> get_flash
    |> Enum.map(&bootstrap_flash_convert/1)
  end

  defp bootstrap_flash_convert(thing) do
    case thing do
      {"error", message} -> {"danger", message}
      _ -> thing
    end
  end
end
