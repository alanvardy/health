defmodule Health.Stats.Calculations do
  @moduledoc "For interpretting statistics"
  alias Health.Stats.Log

  def weight_trend(logs, previous_weight \\ nil, agg \\ [])
  def weight_trend([], _previous_weight, agg), do: Enum.reverse(agg)

  def weight_trend([%Log{date: date, weight: weight} | tail], nil, agg) do
    weight_trend(tail, weight, [%{weight: weight, date: date} | agg])
  end

  def weight_trend([%Log{date: date, weight: weight} | tail], previous_weight, agg) do
    new_weight =
      weight
      |> Kernel.-(previous_weight)
      |> Kernel.*(0.10)
      |> Kernel.+(previous_weight)
      |> Float.round(1)

    weight_trend(tail, new_weight, [%{weight: new_weight, date: date} | agg])
  end
end
