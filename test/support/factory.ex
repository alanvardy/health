defmodule Health.Factory do
  @moduledoc """
  Factory for all test structs
  http://hexdocs.pm/ex_machina/ExMachina.html
  """
  use ExMachina.Ecto, repo: Health.Repo
  alias Health.Account.{EditableUser, User}
  alias Health.Routine.Exercise
  alias Health.Weight.Log

  @spec user_factory :: Health.Account.User.t()
  def user_factory do
    %User{
      name: Faker.StarWars.character(),
      email: Faker.Internet.email(),
      password: "password",
      confirm_password: "password",
      # Member
      roles: 1
    }
  end

  @spec user_factory :: %User{}
  def admin_factory do
    struct!(
      user_factory(),
      %{
        # Admin
        roles: 2
      }
    )
  end

  @spec editable_user_factory :: %EditableUser{}
  def editable_user_factory do
    %EditableUser{
      email: Faker.Internet.email(),
      password: "password",
      confirm_password: "password",
      # Member
      roles: 1
    }
  end

  @spec log_factory :: %Log{}
  def log_factory do
    %Log{
      date: Timex.today(),
      weight: Faker.random_between(100, 240) * (Faker.random_uniform() + 1),
      comment: Faker.StarWars.character(),
      user: build(:user)
    }
  end

  @spec exercise_factory :: %Exercise{}
  def exercise_factory do
    %Exercise{
      name: Faker.StarWars.character(),
      difficulty: Faker.random_between(1, 10),
      description: Faker.StarWars.character()
    }
  end
end
