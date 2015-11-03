defmodule Rumbl.UserView do
  use Rumbl.Web, :view
  alias Rumbl.User

  def render("404.html", _assigns) do
    "You failed, sir"
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.username}
  end

  def first_name(%User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
