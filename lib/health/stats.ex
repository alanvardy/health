defmodule Health.Stats do
  @moduledoc """
  The Stats context.
  """

  alias Ecto.Changeset
  alias Health.Repo
  alias Health.Stats.{Log, Policy}
  alias Health.Users.User
  import Ecto.Query, warn: false

  defdelegate authorize(action, user, params), to: Policy

  @doc """
  Returns the list of log.

  ## Examples

      iex> list_log()
      [%Log{}, ...]

  """

  @spec list_logs(%User{}, Keyword.t()) :: [%Log{}]
  def list_logs(user, opts \\ [])
  def list_logs(user, opts) do
    limit = Keyword.get(opts, :limit, 100)

    Log
    |> where([l], l.user_id == ^user.id)
    |> order_by([l], asc: l.date)
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Gets a single log.

  Raises `Ecto.NoResultsError` if the Log does not exist.

  ## Examples

      iex> get_log!(123)
      %Log{}

      iex> get_log!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_log!(integer) :: %Log{} | :error
  def get_log!(id), do: Repo.get!(Log, id)

  @doc """
  Creates a log.

  ## Examples

      iex> create_log(%{field: value})
      {:ok, %Log{}}

      iex> create_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_log(map):: {:ok, %Log{}} | {:error, %Changeset{}}
  def create_log(attrs \\ %{}) do
    %Log{}
    |> Log.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a log.

  ## Examples

      iex> update_log(log, %{field: new_value})
      {:ok, %Log{}}

      iex> update_log(log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_log(%Log{}, map):: {:ok, %Log{}} | {:error, %Changeset{}}
  def update_log(%Log{} = log, attrs) do
    log
    |> Log.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Log.

  ## Examples

      iex> delete_log(log)
      {:ok, %Log{}}

      iex> delete_log(log)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_log(%Log{}):: {:ok, %Log{}} | {:error, %Changeset{}}
  def delete_log(%Log{} = log) do
    Repo.delete(log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking log changes.

  ## Examples

      iex> change_log(log)
      %Ecto.Changeset{source: %Log{}}

  """
  @spec change_log(%Log{}) :: %Changeset{}
  def change_log(%Log{} = log) do
    Log.changeset(log, %{})
  end
end
