defmodule Mcd.ContentTest do
  use Mcd.DataCase

  alias Mcd.Content

  describe "projects" do
    alias Mcd.Content.Project

    @valid_attrs %{content: "some content", description: "some description", title: "some title"}
    @update_attrs %{content: "some updated content", description: "some updated description", title: "some updated title"}
    @invalid_attrs %{content: nil, description: nil, title: nil}

    def project_fixture(attrs \\ %{}) do
      {:ok, project} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_project()

      project
    end

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Content.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Content.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      assert {:ok, %Project{} = project} = Content.create_project(@valid_attrs)
      assert project.content == "some content"
      assert project.description == "some description"
      assert project.title == "some title"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      assert {:ok, project} = Content.update_project(project, @update_attrs)
      assert %Project{} = project
      assert project.content == "some updated content"
      assert project.description == "some updated description"
      assert project.title == "some updated title"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_project(project, @invalid_attrs)
      assert project == Content.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Content.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Content.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Content.change_project(project)
    end
  end

  describe "topics" do
    alias Mcd.Content.Topic

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def topic_fixture(attrs \\ %{}) do
      {:ok, topic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_topic()

      topic
    end

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      assert Content.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Content.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      assert {:ok, %Topic{} = topic} = Content.create_topic(@valid_attrs)
      assert topic.name == "some name"
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      assert {:ok, topic} = Content.update_topic(topic, @update_attrs)
      assert %Topic{} = topic
      assert topic.name == "some updated name"
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_topic(topic, @invalid_attrs)
      assert topic == Content.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Content.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Content.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Content.change_topic(topic)
    end
  end
end
