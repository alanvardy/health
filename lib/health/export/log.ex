defmodule Health.Export.Log do
  @moduledoc "Export logs as CSV"
  alias Health.Weight.Log

  @doc "Sends a CSV binary"
  @spec export([%Log{}]) :: {binary, String.t()}
  def export(logs) do
    data =
      logs
      |> Enum.map(&convert_log/1)
      |> List.insert_at(0, headers())
      |> CSV.encode()
      |> Enum.join("")

    date = nice_date(Timex.today())

    {date, data}
  end

  defp headers do
    ["Date", "Weight", "Comment"]
  end

  defp convert_log(%Log{date: date, weight: weight, comment: comment}) do
    [nice_date(date), Float.to_string(weight), de_nil(comment)]
  end

  defp nice_date(date) do
    Timex.format!(date, "%Y-%m-%d", :strftime)
  end

  defp de_nil(nil), do: ""
  defp de_nil(comment), do: comment
end
