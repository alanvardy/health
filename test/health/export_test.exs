defmodule Health.ExportTest do
  @moduledoc false

  use Health.DataCase, async: true

  alias Health.Export
  import Health.Factory

  describe "logs/1" do
    test "logs returns a file for export" do
      log1 = build(:log, weight: 150.0)
      log2 = build(:log, weight: 200.0)
      log3 = build(:log, weight: 250.0)

      logs = [log1, log2, log3]
      {date, data} = Export.logs(logs)
      {:ok, today} = Timex.format(Timex.today(), "%Y-%m-%d", :strftime)

      assert date == today
      assert data =~ log1.comment
    end
  end

  describe "measurements/1" do
    test "measurements returns a file for export" do
      measurement1 = build(:measurement)
      measurement2 = build(:measurement)
      measurement3 = build(:measurement)

      measurements = [measurement1, measurement2, measurement3]
      {date, data} = Export.measurements(measurements)
      {:ok, today} = Timex.format(Timex.today(), "%Y-%m-%d", :strftime)

      assert date == today
      assert data =~ measurement1.comment
    end
  end
end
