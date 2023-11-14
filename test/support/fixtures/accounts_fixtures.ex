defmodule Trackster.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Trackster.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Trackster.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  @doc """
  Generate a private_key.
  """
  def private_key_fixture(attrs \\ %{}) do
    {:ok, private_key} =
      attrs
      |> Enum.into(%{

      })
      |> Trackster.Accounts.create_private_key()

    private_key
  end
end
