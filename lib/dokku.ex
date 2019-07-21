defmodule Dokku do
  @app :health
  @repo Health.Repo
  @postgres_username "vardy"

  def backup do
    System.cmd("git", ["remote", "get-url dokku"])
    {:ok, conn} = SSHEx.connect(ip: remote_ip(), user: "root")
    {:ok, output, 0} = SSHEx.run(conn, 'dokku postgres:export #{remote_database()}')
    File.write("latest.dump", output, [])

    System.cmd("pg_restore", [
      "-c",
      "--username=#{@postgres_username}",
      "--dbname=#{local_database()}",
      "latest.dump"
      ])

      IO.puts("Database restore complete")
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
      IO.puts(output)
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
