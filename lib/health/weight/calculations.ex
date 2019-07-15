defmodule Health.Weight.Calculations do
  @moduledoc "For interpretting statistics"
  alias Health.Weight.{Log, Statistics}

  @gaining "Estimated weight gain per week"
  @losing "Estimated weight loss per week"
  @maintaining "No weight change"
  @insufficient "Insufficient information"

  @doc "Takes daily weigh ins and returns adjusted weights with 10% smoothing"
  @spec build_adjusted_weights(Health.Weight.Statistics.t()) :: Health.Weight.Statistics.t()
  def build_adjusted_weights(%Statistics{logs: logs} = stats) do
    %Statistics{stats | adjusted_weights: adjusted_weights(logs)}
  end

  defp adjusted_weights(logs, previous_weight \\ nil, agg \\ [])
  defp adjusted_weights([], _previous_weight, agg), do: Enum.reverse(agg)

  defp adjusted_weights([%Log{date: date, weight: weight} | tail], nil, agg) do
    adjusted_weights(tail, weight, [%{weight: weight, date: date, change: 0} | agg])
  end

  defp adjusted_weights([%Log{date: date, weight: weight} | tail], previous_weight, agg) do
    new_weight =
      weight
      |> Kernel.-(previous_weight)
      |> Kernel.*(0.10)
      |> Kernel.+(previous_weight)
      |> Float.round(1)

    change = new_weight - previous_weight

    adjusted_weights(tail, new_weight, [%{weight: new_weight, date: date, change: change} | agg])
  end

  @spec build_trend(Health.Weight.Statistics.t()) :: Health.Weight.Statistics.t()
  def build_trend(%Statistics{adjusted_weights: adjusted_weights} = stats) do
    %Statistics{stats | trend: estimate_trend(adjusted_weights)}
  end

  @spec estimate_trend(list) :: %{change: number, text: String.t()}
  defp estimate_trend([]), do: %{change: 0, text: @insufficient}

  defp estimate_trend(adjusted_weights) do
    adjusted_weights
    |> Enum.take(14)
    |> Enum.reduce(0, fn w, acc -> w.change + acc end)
    |> divide(adjusted_weights)
    |> Kernel.*(7)
    |> interpret_trend()
  end

  defp divide(sum, adjusted_weights) do
    case Enum.count(adjusted_weights) do
      count when count > 14 -> sum / 14
      count when count < 3 -> sum
      count -> sum / (count - 1)
    end
  end

  defp interpret_trend(change) when change > 0, do: %{change: normalise(change), text: @gaining}
  defp interpret_trend(change) when change < 0, do: %{change: normalise(change), text: @losing}
  defp interpret_trend(change) when change == 0, do: %{change: 0, text: @maintaining}

  defp normalise(number) do
    number
    |> abs()
    |> Float.round(1)
  end
end
