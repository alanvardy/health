defmodule Health.Export.Measurement do
  @moduledoc "Export measurements as CSV"
  alias Health.Dimension.Measurement

  @doc "Sends a CSV binary"
  @spec export([%Measurement{}]) :: {binary, String.t()}
  def export(measurements) do
    data =
      measurements
      |> Enum.map(&convert_measurement/1)
      |> List.insert_at(0, headers())
      |> CSV.encode()
      |> Enum.join("")

    date = nice_date(Timex.today())

    {date, data}
  end

  defp headers do
    [
      "Date",
      "Left Bicep",
      "Right Bicep",
      "Left Thigh",
      "Right Thigh",
      "Chest",
      "Waist",
      "Buttocks",
      "Comment"
    ]
  end

  defp convert_measurement(measurement) do
    [
      nice_date(measurement.date),
      Float.to_string(measurement.left_bicep),
      Float.to_string(measurement.right_bicep),
      Float.to_string(measurement.left_thigh),
      Float.to_string(measurement.right_thigh),
      Float.to_string(measurement.chest),
      Float.to_string(measurement.waist),
      Float.to_string(measurement.buttocks),
      de_nil(measurement.comment)
    ]
  end

  defp nice_date(date) do
    Timex.format!(date, "%Y-%m-%d", :strftime)
  end

  defp de_nil(nil), do: ""
  defp de_nil(comment), do: comment
end
