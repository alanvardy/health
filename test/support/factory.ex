defmodule Health.Factory do
  @moduledoc """
  Factory for all test structs
  http://hexdocs.pm/ex_machina/ExMachina.html
  """
  use ExMachina.Ecto, repo: Health.Repo
  alias Health.Account.{EditableUser, User}
  alias Health.Routine.Exercise
  alias Health.Weight.Log

  @spec user_factory :: User.t()
  def user_factory do
    %User{
      email: Faker.Internet.email(),
      password: "password",
      confirm_password: "password",
      # Member
      roles: 1
    }
  end

  def admin_user_factory do
    struct!(
      user_factory(),
      %{
        # Admin
        roles: 2
      }
    )
  end

  @spec editable_user_factory :: EditableUser.t()
  def editable_user_factory do
    %EditableUser{
      email: Faker.Internet.email(),
      password: "password",
      confirm_password: "password",
      # Member
      roles: 1
    }
  end

  @spec log_factory :: Log.t()
  def log_factory do
    %Log{
      date: Timex.today(),
      weight: Faker.random_between(100, 400),
      comment: Faker.StarWars.character(),
      user: build(:user)
    }
  end

  @spec exercise_factory :: Exercise.t()
  def exercise_factory do
    %Exercise{
      name: Faker.StarWars.character(),
      difficulty: Faker.random_between(1, 10),
      description: Faker.StarWars.character()
    }
  end
end
