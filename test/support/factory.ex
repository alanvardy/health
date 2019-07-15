defmodule Health.Factory do
  @moduledoc """
  Factory for all test structs
  http://hexdocs.pm/ex_machina/ExMachina.html
  """
  use ExMachina.Ecto, repo: Health.Repo
  alias Health.Account.User
  alias Health.Weight.Log

  def user_factory do
    %User{
      email: "user@example.com",
      password: "password",
      confirm_password: "password"
    }
  end

  def log_factory do
    %Log{
      date: Timex.today(),
      weight: 230,
      user: build(:user)
    }
  end

end
