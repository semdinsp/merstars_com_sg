defmodule MerstarsComSg.Inquiries do
  @moduledoc """
  Contact-us messages and quote requests from the website.

  Each valid submission is emailed to the team and, when a database is
  configured (see `MerstarsComSg.database?/0`), also saved so nothing is lost
  if the email fails.
  """
  require Logger

  alias MerstarsComSg.Inquiries.{Inquiry, InquiryNotifier}
  alias MerstarsComSg.Repo

  def change_inquiry(kind, attrs \\ %{}) do
    Inquiry.changeset(%Inquiry{}, kind, attrs)
  end

  @doc """
  Validates, saves (if there is a database) and emails a submission.

  Returns `{:ok, inquiry}` when it was saved or emailed (the team has it),
  `{:error, changeset}` for invalid input, and `{:error, :delivery_failed}`
  when it could be neither saved nor emailed.
  """
  def submit(kind, attrs) do
    changeset = change_inquiry(kind, attrs)

    with {:ok, inquiry} <- Ecto.Changeset.apply_action(changeset, :insert) do
      stored = store(changeset)
      emailed? = email(stored || inquiry)

      cond do
        stored && emailed? -> {:ok, mark_emailed(stored)}
        stored || emailed? -> {:ok, stored || inquiry}
        true -> {:error, :delivery_failed}
      end
    end
  end

  defp store(changeset) do
    if MerstarsComSg.database?() do
      case Repo.insert(changeset) do
        {:ok, inquiry} ->
          inquiry

        {:error, reason} ->
          Logger.error("Could not save inquiry: #{inspect(reason)}")
          nil
      end
    end
  rescue
    error ->
      Logger.error("Could not save inquiry: #{Exception.message(error)}")
      nil
  end

  defp email(inquiry) do
    if Application.get_env(:merstars_com_sg, :inquiries, [])[:deliver] do
      case InquiryNotifier.deliver(inquiry) do
        {:ok, _email} ->
          true

        {:error, reason} ->
          Logger.error("Could not email inquiry: #{inspect(reason)}")
          false
      end
    else
      Logger.error("Inquiry email is not configured (AWS SES keys missing); not sent")
      false
    end
  end

  defp mark_emailed(inquiry) do
    inquiry
    |> Ecto.Changeset.change(emailed_at: DateTime.utc_now(:second))
    |> Repo.update!()
  end
end
