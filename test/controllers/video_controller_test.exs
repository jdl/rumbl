defmodule Rumbl.VideoControllerTest do
  use Rumbl.ConnCase

  alias Rumbl.Video
  alias Rumbl.TestHelper

  @valid_attrs %{description: "some content", title: "some content", url: "some content"}
  @invalid_attrs %{title: nil}

  setup do
    {:ok, category} = TestHelper.create_category(%{name: "Westerns"})
    {:ok, user} = TestHelper.create_user(%{name: "Foo", username: "foo", password: "foobar"})
    {:ok, video} = TestHelper.create_video(user, category, %{url: "http://example.com/abc123", title: "Movie Scene", description: "This is a movie" })

    conn = conn() |> login_user(user)
    {:ok, conn: conn, user: user, video: video, category: category}
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create), session: %{username: user.username, password: user.password}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, video_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing videos"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, video_path(conn, :new)
    assert html_response(conn, 200) =~ "New video"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, video_path(conn, :create), video: @valid_attrs
    assert redirected_to(conn) == video_path(conn, :index)
    assert Repo.get_by(Video, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, video_path(conn, :create), video: @invalid_attrs
    assert html_response(conn, 200) =~ "New video"
  end

  test "shows chosen resource", %{conn: conn, video: video} do
    conn = get conn, video_path(conn, :show, video)
    assert html_response(conn, 200) =~ "Show video"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.CastError, fn ->
      get conn, video_path(conn, :show, "-1")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, video: video} do
    conn = get conn, video_path(conn, :edit, video)
    assert html_response(conn, 200) =~ "Edit video"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user, category: category, video: video} do
    conn = put conn, video_path(conn, :update, video), video: @valid_attrs
    expected_video = Repo.get(Video, video.id)
    assert redirected_to(conn) == video_path(conn, :show, expected_video)
    assert Repo.get_by(Video, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, video: video} do
    conn = put conn, video_path(conn, :update, video), video: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit video"
  end

  test "deletes chosen resource", %{conn: conn, video: video} do
    conn = delete conn, video_path(conn, :delete, video)
    assert redirected_to(conn) == video_path(conn, :index)
    refute Repo.get(Video, video.id)
  end
end
