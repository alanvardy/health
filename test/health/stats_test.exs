defmodule Health.StatsTest do
  @moduledoc false

  use Health.DataCase

  alias Health.Stats
  alias Health.Stats.Log
  import Health.Factory

  describe "log" do

    test "list_log/0 returns all logs" do
      user = insert(:user)
      log = insert(:log, user: user)
      left = remove_user(Stats.list_logs(user))
      right = [remove_user(log)]
      assert left == right
    end

    test "get_log!/1 returns the log with given id" do
      log = insert(:log)
      left = remove_user(Stats.get_log!(log.id))
      right = remove_user(log)
      assert left == right
    end

      test "create_log/1 with valid data creates a log" do
        user = insert(:user)
        assert {:ok, %Log{} = log} = Stats.create_log(params_for(:log, user: user))
        assert log.date == Timex.today
        assert log.weight == 230
      end

      test "create_log/1 with invalid data returns error changeset" do
        assert {:error, %Ecto.Changeset{}} = Stats.create_log(params_for(:log, weight: 50))
      end

      test "update_log/2 with valid data updates the log" do
        log = insert(:log)
        assert {:ok, %Log{} = log} = Stats.update_log(log, params_for(:log, weight: 400))
        assert log.date == Timex.today()
        assert log.weight == 400
      end

      test "update_log/2 with invalid data returns error changeset" do
        log = insert(:log)
        assert {:error, %Ecto.Changeset{}} = Stats.update_log(log, params_for(:log, weight: 1000))
        # assert log == Stats.get_log!(log.id)
      end

      test "delete_log/1 deletes the log" do
        log = insert(:log)
        assert {:ok, %Log{}} = Stats.delete_log(log)
        assert_raise Ecto.NoResultsError, fn -> Stats.get_log!(log.id) end
      end

  end

  defp remove_user([log]), do: [%Log{log | user: nil}]
  defp remove_user(log), do: %Log{log | user: nil}
end
