defmodule MerstarsComSg.Inquiries.InquiryNotifier do
  @moduledoc """
  Emails a website inquiry to the Merstar team, with Reply-To set to the
  visitor so the team can answer directly. Addresses come from the
  `:inquiries` config (see `config/runtime.exs`).
  """
  import Swoosh.Email

  alias MerstarsComSg.Inquiries.Inquiry
  alias MerstarsComSg.Mailer

  @labels [
    name: "Name",
    company: "Company",
    email: "Email",
    phone: "Phone",
    subject: "Subject",
    origin: "Origin",
    destination: "Destination",
    message: "Message"
  ]

  def deliver(%Inquiry{} = inquiry) do
    config = Application.get_env(:merstars_com_sg, :inquiries, [])

    email =
      new()
      |> to(config[:to])
      |> from({"Merstar website", config[:from]})
      |> reply_to({inquiry.name, inquiry.email})
      |> subject(subject_line(inquiry))
      |> text_body(body(inquiry))

    with {:ok, _metadata} <- Mailer.deliver(email), do: {:ok, email}
  end

  defp subject_line(%Inquiry{kind: "quote"} = i),
    do: "Quote request: #{i.origin} → #{i.destination} (#{i.name})"

  defp subject_line(%Inquiry{} = i),
    do: "Website enquiry from #{i.name}" <> if(i.subject, do: ": #{i.subject}", else: "")

  defp body(%Inquiry{} = inquiry) do
    heading = if inquiry.kind == "quote", do: "Request for quote", else: "Contact form message"

    fields =
      for {key, label} <- @labels, value = Map.get(inquiry, key), value not in [nil, ""] do
        if key == :message, do: "\n#{label}:\n#{value}", else: "#{label}: #{value}"
      end

    Enum.join(["#{heading} from merstar.com.sg", "" | fields], "\n") <>
      "\n\nReply to this email to answer #{inquiry.name} directly.\n"
  end
end
