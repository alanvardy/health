defmodule Health.Export do
  @moduledoc "Exports user data"
  alias Health.Export.{Log, Measurement}

  @spec logs([Health.Weight.Log.t()]) :: {binary, binary}
  def logs(logs), do: Log.export(logs)

  @spec measurements([Health.Dimension.Measurement.t()]) :: {binary, binary}
  def measurements(measurements), do: Measurement.export(measurements)
end
