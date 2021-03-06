defmodule Health.Weight.Calculations do
  @moduledoc "For interpretting statistics"
  alias Health.Weight.{Log, Stats}

  @gaining "Estimated weight gain per week"
  @losing "Estimated weight loss per week"
  @maintaining "No weight change"
  @insufficient "Insufficient information"

  @doc "Takes daily weigh ins and returns adjusted weights with 10% smoothing"
  @spec build_adjusted_weights(%Stats{}) :: %Stats{}
  def build_adjusted_weights(%Stats{logs: logs} = stats) do
    adjusted_logs =
      logs
      |> fill_in_blanks()
      |> adjusted_weights()

    %Stats{stats | adjusted_weights: adjusted_logs}
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

  defp fill_in_blanks(logs) do
    logs
  end

  @spec build_trend(Health.Weight.Stats.t()) :: Health.Weight.Stats.t()
  def build_trend(%Stats{adjusted_weights: adjusted_weights} = stats) do
    %Stats{stats | trend: trend(adjusted_weights)}
  end

  @spec trend(list) :: %{change: number, text: String.t()}
  defp trend([]), do: %{change: 0, text: @insufficient}

  defp trend(adjusted_weights) do
    trends =
      adjusted_weights
      |> Enum.take(-14)
      |> Enum.filter(fn t -> Timex.diff(Timex.today(), t.date, :days) < 14 end)

    trends
    |> Enum.reduce(0, fn w, acc -> w.change + acc end)
    |> divide(trends)
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
