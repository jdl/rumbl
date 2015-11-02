defmodule Rumbl.TestHelper do
  alias Rumbl.Repo
  alias Rumbl.User
  alias Rumbl.Category
  alias Rumbl.Video

  import Ecto.Model

  def create_category(%{name: name}) do
    Category.changeset(%Category{}, %{name: name}) |> Repo.insert
  end

  def create_user(%{name: name, username: username, password: password}) do
    User.registration_changeset(%User{}, %{name: name, username: username, password: password})
    |> Repo.insert
  end

  def create_video(user, category, %{url: url, title: title, description: description}) do
    user
    |> build(:videos)
    |> Video.changeset(%{url: url, title: title, description: description, category_id: category.id})
    |> Repo.insert
  end
end
