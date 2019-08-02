defmodule HealthWeb.MeasurementView do
  use HealthWeb, :view

  @spec average([number]) :: float
  def average(list) do
    list
    |> Enum.reduce(0, fn x, acc -> x + acc end)
    |> Kernel./(length(list))
    |> Float.round(1)
  end
end
