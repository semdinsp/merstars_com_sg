defmodule MerstarsComSg do
  @moduledoc """
  MerstarsComSg keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
  Whether a database is configured. Always true in dev and test; in prod it
  depends on DATABASE_URL being set (see `config/runtime.exs`).
  """
  def database?, do: Application.get_env(:merstars_com_sg, :database, true)
end
