defmodule Health.Weight.Export do
  @moduledoc "Exports Weight data"
  alias Health.Weight.Log

  @doc "Sends a CSV binary"
  @spec csv([%Log{}]) :: {binary, String.t()}
  def csv(logs) do
    data =
      logs
      |> Enum.map(&convert_log/1)
      |> List.insert_at(0, headers())
      |> CSV.encode()
      # |> Enum.into(File.stream!("logs.csv"))
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
