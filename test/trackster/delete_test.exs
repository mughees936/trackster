defmodule Trackster.DeleteTest do
  use Trackster.DataCase

  alias Trackster.Delete

  describe "deletes" do
    alias Trackster.Delete.Redo

    import Trackster.DeleteFixtures

    @invalid_attrs %{}

    test "list_deletes/0 returns all deletes" do
      redo = redo_fixture()
      assert Delete.list_deletes() == [redo]
    end

    test "get_redo!/1 returns the redo with given id" do
      redo = redo_fixture()
      assert Delete.get_redo!(redo.id) == redo
    end

    test "create_redo/1 with valid data creates a redo" do
      valid_attrs = %{}

      assert {:ok, %Redo{} = redo} = Delete.create_redo(valid_attrs)
    end

    test "create_redo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Delete.create_redo(@invalid_attrs)
    end

    test "update_redo/2 with valid data updates the redo" do
      redo = redo_fixture()
      update_attrs = %{}

      assert {:ok, %Redo{} = redo} = Delete.update_redo(redo, update_attrs)
    end

    test "update_redo/2 with invalid data returns error changeset" do
      redo = redo_fixture()
      assert {:error, %Ecto.Changeset{}} = Delete.update_redo(redo, @invalid_attrs)
      assert redo == Delete.get_redo!(redo.id)
    end

    test "delete_redo/1 deletes the redo" do
      redo = redo_fixture()
      assert {:ok, %Redo{}} = Delete.delete_redo(redo)
      assert_raise Ecto.NoResultsError, fn -> Delete.get_redo!(redo.id) end
    end

    test "change_redo/1 returns a redo changeset" do
      redo = redo_fixture()
      assert %Ecto.Changeset{} = Delete.change_redo(redo)
    end
  end
end
