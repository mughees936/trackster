defmodule Trackster.DeleteFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Trackster.Delete` context.
  """

  @doc """
  Generate a redo.
  """
  def redo_fixture(attrs \\ %{}) do
    {:ok, redo} =
      attrs
      |> Enum.into(%{

      })
      |> Trackster.Delete.create_redo()

    redo
  end
end
