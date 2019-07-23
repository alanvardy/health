defmodule Mix.Tasks.PullDokkuDatabase do
  @moduledoc """
  For
  """
  @app :health
  @repo Health.Repo
  @postgres_username "postgres"

  @spec run(any) :: :ok
  def run(_args) do
    {:ok, _started} = Application.ensure_all_started(:sshex)

    output =
      SSHEx.connect(ip: remote_ip(), user: "root")
      |> elem(1)
      |> SSHEx.run('dokku postgres:export #{remote_database()}')

    case output do
      {:ok, output, 0} ->
        File.write("latest.dump", output, [])

        System.cmd("pg_restore", [
          "-c",
          "--username=#{@postgres_username}",
          "--dbname=#{local_database()}",
          "latest.dump"
        ])

        IO.puts("Database restore complete")

      _ ->
        IO.puts("Unable to connect to database")
    end
  end

  defp remote_ip do
    remote()
    |> Map.get("ip")
  end

  defp remote_app do
    remote()
    |> Map.get("app")
  end

  def local_database do
    local()
    |> Keyword.get(@repo)
    |> Keyword.get(:database)
  end

  def remote_database do
    {:ok, conn} = SSHEx.connect(ip: remote_ip(), user: "root")
    {:ok, output, 0} = SSHEx.run(conn, 'dokku postgres:app-links #{remote_app()}')
    String.trim(output)
  end

  defp local do
    Application.get_all_env(@app)
  end

  defp remote do
    {result, 0} = System.cmd("git", ["remote", "get-url", "dokku"], stderr_to_stdout: true)

    ~r/dokku@(?<ip>\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}):(?<app>\w+)\n/
    |> Regex.named_captures(result)
  end
end
