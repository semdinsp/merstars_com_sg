defmodule MerstarsComSg.InquiriesTest do
  use MerstarsComSg.DataCase, async: false

  @moduletag :capture_log

  import Swoosh.TestAssertions

  alias MerstarsComSg.Inquiries
  alias MerstarsComSg.Inquiries.Inquiry

  @contact %{
    "name" => "Ana Lim",
    "email" => "ana@example.com",
    "phone" => "+65 9123 4567",
    "subject" => "Airfreight to Seoul",
    "message" => "Two pallets, ready next week."
  }

  @quote %{
    "name" => "Ben Tan",
    "company" => "Acme Pte Ltd",
    "email" => "ben@example.com",
    "origin" => "Singapore (SIN)",
    "destination" => "Rotterdam (RTM)",
    "message" => "1x20ft, general cargo"
  }

  describe "submit/2" do
    test "saves and emails a contact message, with Reply-To set to the visitor" do
      assert {:ok, %Inquiry{kind: "contact", emailed_at: %DateTime{}}} =
               Inquiries.submit("contact", @contact)

      assert [%Inquiry{name: "Ana Lim"}] = Repo.all(Inquiry)

      assert_email_sent(fn email ->
        assert email.to == [{"", "sales@merstar.com.sg"}]
        assert email.reply_to == {"Ana Lim", "ana@example.com"}
        assert email.subject == "Website enquiry from Ana Lim: Airfreight to Seoul"
        assert email.text_body =~ "Two pallets, ready next week."
      end)
    end

    test "emails a quote request with the lane in the subject" do
      assert {:ok, %Inquiry{kind: "quote"}} = Inquiries.submit("quote", @quote)

      assert_email_sent(subject: "Quote request: Singapore (SIN) → Rotterdam (RTM) (Ben Tan)")
    end

    test "rejects missing fields and bad email without saving or sending" do
      attrs = %{@quote | "origin" => "", "email" => "not-an-email"}

      assert {:error, %Ecto.Changeset{} = changeset} = Inquiries.submit("quote", attrs)
      assert %{origin: [_], email: ["Please enter a valid email address"]} = errors_on(changeset)
      assert Repo.all(Inquiry) == []
      assert_no_email_sent()
    end

    test "ignores fields that aren't on the form" do
      assert {:ok, inquiry} = Inquiries.submit("contact", Map.put(@contact, "origin", "SIN"))
      assert inquiry.origin == nil
    end

    test "without a database, only emails the submission" do
      put_app_env(:database, false)

      assert {:ok, %Inquiry{id: nil}} = Inquiries.submit("contact", @contact)
      assert Repo.all(Inquiry) == []
      assert_email_sent(subject: "Website enquiry from Ana Lim: Airfreight to Seoul")
    end

    test "when email is not configured, still saves the submission" do
      put_app_env(:inquiries, Keyword.put(inquiries_config(), :deliver, false))

      assert {:ok, %Inquiry{emailed_at: nil}} = Inquiries.submit("contact", @contact)
      assert [_] = Repo.all(Inquiry)
      assert_no_email_sent()
    end

    test "fails when it can be neither saved nor emailed" do
      put_app_env(:database, false)
      put_app_env(:inquiries, Keyword.put(inquiries_config(), :deliver, false))

      assert {:error, :delivery_failed} = Inquiries.submit("contact", @contact)
    end
  end

  defp inquiries_config, do: Application.get_env(:merstars_com_sg, :inquiries)

  defp put_app_env(key, value) do
    previous = Application.get_env(:merstars_com_sg, key)
    Application.put_env(:merstars_com_sg, key, value)

    on_exit(fn ->
      if is_nil(previous),
        do: Application.delete_env(:merstars_com_sg, key),
        else: Application.put_env(:merstars_com_sg, key, previous)
    end)
  end
end
