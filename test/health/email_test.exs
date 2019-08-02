defmodule Health.EmailTest do
  @moduledoc false
  alias Health.Email
  use Health.DataCase, async: true

  @good_params %{
    name: Faker.StarWars.character(),
    from_email: Faker.Internet.email(),
    message: Faker.Lorem.sentence(10..50)
  }

  describe "contact_message" do
    test "returns a Bamboo.Email struct when passed good data" do
      response = Email.contact_message(@good_params)
      assert {:ok, %Bamboo.Email{} = struct} = response

      assert struct.from == Map.get(@good_params, :from_email)
    end
  end
end
