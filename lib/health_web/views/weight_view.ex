defmodule HealthWeb.WeightView do
  use HealthWeb, :view

  @spec dates_and_weights([any], integer) :: {[any], [any]}
  def dates_and_weights(list, length) do
    dates = list
    |> Enum.take(0 - length)
    |> Enum.map(fn x -> x.date end)

    weights = list
    |> Enum.take(0 - length)
    |> Enum.map(fn x -> x.weight end)

    {dates, weights}
  end
end
