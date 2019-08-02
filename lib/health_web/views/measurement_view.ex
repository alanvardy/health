defmodule HealthWeb.MeasurementView do
  use HealthWeb, :view

  @spec average([number]) :: float
  def average(list) do
    list
    |> Enum.reduce(0, fn x, acc -> x + acc end)
    |> Kernel./(length(list))
    |> Float.round(1)
  end

  def dates_and_measurements(list, measurement, length) do
    dates =
      list
      |> Enum.take(0 - length)
      |> Enum.map(fn x -> x.date end)

    measurements =
      list
      |> Enum.take(0 - length)
      |> Enum.map(fn x -> Map.get(x, measurement) end)

    {dates, measurements}
  end
end
