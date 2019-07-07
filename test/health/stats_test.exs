defmodule Health.StatsTest do
  use Health.DataCase

  alias Health.Stats

  describe "log" do
    alias Health.Stats.Log

    @valid_attrs %{date: "2010-04-17T14:00:00Z", weight: 42, user_id: 1}
    @update_attrs %{date: "2011-05-18T15:01:01Z", weight: 43, user_id: 2}
    @invalid_attrs %{date: nil, weight: nil, user_id: nil}

  #   def log_fixture(attrs \\ %{}) do
  #     {:ok, log} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Stats.create_log()

  #     log
  #   end

  #   test "list_log/0 returns all log" do
  #     log = log_fixture()
  #     assert Stats.list_log() == [log]
  #   end

  #   test "get_log!/1 returns the log with given id" do
  #     log = log_fixture()
  #     assert Stats.get_log!(log.id) == log
  #   end

  #   test "create_log/1 with valid data creates a log" do
  #     assert {:ok, %Log{} = log} = Stats.create_log(@valid_attrs)
  #     assert log.date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
  #     assert log.weight == 42
  #   end

  #   test "create_log/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Stats.create_log(@invalid_attrs)
  #   end

  #   test "update_log/2 with valid data updates the log" do
  #     log = log_fixture()
  #     assert {:ok, %Log{} = log} = Stats.update_log(log, @update_attrs)
  #     assert log.date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
  #     assert log.weight == 43
  #   end

  #   test "update_log/2 with invalid data returns error changeset" do
  #     log = log_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Stats.update_log(log, @invalid_attrs)
  #     assert log == Stats.get_log!(log.id)
  #   end

  #   test "delete_log/1 deletes the log" do
  #     log = log_fixture()
  #     assert {:ok, %Log{}} = Stats.delete_log(log)
  #     assert_raise Ecto.NoResultsError, fn -> Stats.get_log!(log.id) end
  #   end

  #   test "change_log/1 returns a log changeset" do
  #     log = log_fixture()
  #     assert %Ecto.Changeset{} = Stats.change_log(log)
  #   end
  end
end
