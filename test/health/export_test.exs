defmodule Health.ExportTest do
  @moduledoc false

  use Health.DataCase, async: true

  alias Health.Weight.Export
  import Health.Factory

  describe "csv" do
    test "csv returns a file for export" do
      log1 = build(:log, weight: 150.0)
      log2 = build(:log, weight: 200.0)
      log3 = build(:log, weight: 250.0)

      logs = [log1, log2, log3]
      {date, data} = Export.csv(logs)
      {:ok, today} = Timex.format(Timex.today(), "%Y-%m-%d", :strftime)

      assert date == today
      assert data =~ log1.comment
    end
  end
end
