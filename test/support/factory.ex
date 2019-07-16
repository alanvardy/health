defmodule Health.Factory do
  @moduledoc """
  Factory for all test structs
  http://hexdocs.pm/ex_machina/ExMachina.html
  """
  use ExMachina.Ecto, repo: Health.Repo
  alias Health.Account.User
  alias Health.Weight.Log

  @spec user_factory :: Health.Account.User.t()
  def user_factory do
    %User{
      email: "user@example.com",
      password: "password",
      confirm_password: "password"
    }
  end

  @spec log_factory :: Health.Weight.Log.t()
  def log_factory do
    %Log{
      date: Timex.today(),
      weight: 230,
      comment: "I feel rather pretty today!",
      user: build(:user)
    }
  end

  @spec exercise_factory :: Health.Exercise.t()
  def exercise_factory do
    %Health.Exercise{
      name: "Barbell Press",
      difficulty: 3,
      description: "This is the barbell press"
    }
  end

end
