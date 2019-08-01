defmodule HealthWeb.ContactController do
  use HealthWeb, :controller
  alias Health.Email.{Contact, Content}
  alias Health.Email

  @spec new(%Plug.Conn{}, map) :: %Plug.Conn{}
  def new(conn, _params) do
    changeset = Contact.changeset(%Content{}, %{})

    conn
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{message: message_params}) do
    case Email.send_contact_message(message_params) do
      {:ok, _message} ->
        conn
        |> put_flash(:info, "Your message has been sent!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Your message could not be created")
        |> render("contact.html", changeset: changeset)
    end
  end
end
