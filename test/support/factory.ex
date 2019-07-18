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
      email: Faker.Internet.email(),
      password: "password",
      confirm_password: "password",
      roles: 1 # Member
    }
  end

  def admin_user_factory do
    struct!(
    user_factory(),
      %{
        roles: 2 # Admin
      }
    )
  end

  @spec log_factory :: Health.Weight.Log.t()
  def log_factory do
    %Log{
      date: Timex.today(),
      weight: Faker.random_between(100, 400),
      comment: Faker.StarWars.character(),
      user: build(:user)
    }
  end

  @spec exercise_factory :: Health.Exercise.t()
  def exercise_factory do
    %Health.Exercise{
      name: Faker.StarWars.character(),
      difficulty: Faker.random_between(1, 10),
      description: Faker.StarWars.character()
    }
  end

end
