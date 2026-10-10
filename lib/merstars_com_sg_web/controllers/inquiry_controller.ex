defmodule MerstarsComSgWeb.InquiryController do
  @moduledoc """
  Handles contact-us and request-for-quote submissions: honeypot, Cloudflare
  Turnstile check, then `MerstarsComSg.Inquiries.submit/2`.
  """
  use MerstarsComSgWeb, :controller

  alias MerstarsComSg.{Inquiries, Turnstile}

  @pages %{
    "contact" => %{template: :contact, path: "/contact-us"},
    "quote" => %{template: :request_quote, path: "/request-for-quote"}
  }

  @captcha_error "Please complete the verification check and try again."
  @failed_error "Sorry, we couldn't send your message. Please email sales@merstar.com.sg or call (65) 6545-8833."

  def contact(conn, params), do: create(conn, "contact", params)
  def quote(conn, params), do: create(conn, "quote", params)

  defp create(conn, kind, params) do
    attrs = Map.get(params, "inquiry", %{})

    cond do
      # Bots that fill the hidden field get the normal success response.
      params["website"] not in [nil, ""] ->
        sent(conn, kind)

      Turnstile.verify(params["cf-turnstile-response"], kind, client_ip(conn)) != :ok ->
        form = kind |> Inquiries.change_inquiry(attrs) |> Map.put(:action, :validate)
        rerender(conn, kind, form, captcha_error: @captcha_error)

      true ->
        case Inquiries.submit(kind, attrs) do
          {:ok, _inquiry} ->
            sent(conn, kind)

          {:error, %Ecto.Changeset{} = changeset} ->
            rerender(conn, kind, changeset, [])

          {:error, :delivery_failed} ->
            changeset = Inquiries.change_inquiry(kind, attrs)

            conn
            |> put_flash(:error, @failed_error)
            |> rerender(kind, changeset, [])
        end
    end
  end

  defp sent(conn, kind) do
    message =
      if kind == "quote",
        do: "Thank you — we've received your quote request and will be in touch shortly.",
        else: "Thank you for your message — we'll get back to you soon."

    conn
    |> put_flash(:info, message)
    |> redirect(to: @pages[kind].path <> "#form")
  end

  defp rerender(conn, kind, changeset, assigns) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(MerstarsComSgWeb.PageHTML)
    |> render(
      @pages[kind].template,
      [form: Phoenix.Component.to_form(changeset, as: :inquiry)] ++ assigns
    )
  end

  # Fly's proxy passes the visitor's IP in Fly-Client-IP.
  defp client_ip(conn) do
    case get_req_header(conn, "fly-client-ip") do
      [ip | _] -> ip
      [] -> conn.remote_ip |> :inet.ntoa() |> to_string()
    end
  end
end
