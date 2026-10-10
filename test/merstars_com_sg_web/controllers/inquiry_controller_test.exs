defmodule MerstarsComSgWeb.InquiryControllerTest do
  use MerstarsComSgWeb.ConnCase, async: false

  @moduletag :capture_log

  import Swoosh.TestAssertions

  alias MerstarsComSg.Inquiries.Inquiry
  alias MerstarsComSg.Repo

  @contact %{
    "name" => "Ana Lim",
    "email" => "ana@example.com",
    "subject" => "Airfreight",
    "message" => "Two pallets to Seoul."
  }

  @quote %{
    "name" => "Ben Tan",
    "email" => "ben@example.com",
    "origin" => "SIN",
    "destination" => "RTM",
    "message" => "1x20ft general cargo"
  }

  defp stub_turnstile(response) do
    Req.Test.stub(MerstarsComSg.Turnstile, fn conn ->
      send(self(), {:siteverify, Plug.Conn.read_body(conn)})
      Req.Test.json(conn, response)
    end)
  end

  defp submit(conn, path, attrs, extra \\ %{}) do
    post(conn, path, Map.merge(%{"inquiry" => attrs, "cf-turnstile-response" => "token"}, extra))
  end

  describe "POST /contact-us" do
    test "verifies Turnstile, saves and emails the message, then redirects", %{conn: conn} do
      stub_turnstile(%{"success" => true})

      conn = submit(conn, ~p"/contact-us", @contact)

      assert redirected_to(conn) == "/contact-us#form"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Thank you"
      assert [%Inquiry{kind: "contact", name: "Ana Lim"}] = Repo.all(Inquiry)
      assert_email_sent(subject: "Website enquiry from Ana Lim: Airfreight")

      assert html_response(get(recycle(conn), ~p"/contact-us"), 200) =~
               "Thank you for your message"
    end

    test "rejects a failed Turnstile check without saving or sending", %{conn: conn} do
      stub_turnstile(%{"success" => false, "error-codes" => ["invalid-input-response"]})

      html = conn |> submit(~p"/contact-us", @contact) |> html_response(422)

      assert html =~ "Please complete the verification check"
      assert html =~ ~s(value="Ana Lim")
      assert Repo.all(Inquiry) == []
      assert_no_email_sent()
    end

    test "rejects a submission with no Turnstile token", %{conn: conn} do
      html = conn |> post(~p"/contact-us", %{"inquiry" => @contact}) |> html_response(422)

      assert html =~ "Please complete the verification check"
      refute_received {:siteverify, _}
      assert Repo.all(Inquiry) == []
    end

    test "re-shows the form with errors for missing fields", %{conn: conn} do
      stub_turnstile(%{"success" => true})

      html =
        conn
        |> submit(~p"/contact-us", %{@contact | "email" => "nope", "message" => ""})
        |> html_response(422)

      assert html =~ "Please enter a valid email address"
      assert html =~ "Please fill this in"
      assert Repo.all(Inquiry) == []
      assert_no_email_sent()
    end

    test "quietly drops submissions that fill the honeypot", %{conn: conn} do
      conn = submit(conn, ~p"/contact-us", @contact, %{"website" => "http://spam.example"})

      assert redirected_to(conn) == "/contact-us#form"
      refute_received {:siteverify, _}
      assert Repo.all(Inquiry) == []
      assert_no_email_sent()
    end
  end

  describe "POST /request-for-quote" do
    test "saves and emails the quote request", %{conn: conn} do
      stub_turnstile(%{"success" => true})

      conn = submit(conn, ~p"/request-for-quote", @quote)

      assert redirected_to(conn) == "/request-for-quote#form"
      assert [%Inquiry{kind: "quote", origin: "SIN"}] = Repo.all(Inquiry)
      assert_email_sent(subject: "Quote request: SIN → RTM (Ben Tan)")
    end
  end

  describe "with production hostname checks" do
    setup do
      previous = Application.get_env(:merstars_com_sg, :turnstile)

      Application.put_env(
        :merstars_com_sg,
        :turnstile,
        Keyword.put(previous, :hostnames, ["merstar.com.sg"])
      )

      on_exit(fn -> Application.put_env(:merstars_com_sg, :turnstile, previous) end)
    end

    test "accepts a token for this site and form", %{conn: conn} do
      stub_turnstile(%{"success" => true, "hostname" => "merstar.com.sg", "action" => "quote"})

      conn = submit(conn, ~p"/request-for-quote", @quote)
      assert redirected_to(conn) == "/request-for-quote#form"
    end

    test "rejects a token issued for the other form", %{conn: conn} do
      stub_turnstile(%{"success" => true, "hostname" => "merstar.com.sg", "action" => "contact"})

      conn |> submit(~p"/request-for-quote", @quote) |> html_response(422)
      assert Repo.all(Inquiry) == []
    end

    test "rejects a token from another hostname", %{conn: conn} do
      stub_turnstile(%{"success" => true, "hostname" => "evil.example", "action" => "quote"})

      conn |> submit(~p"/request-for-quote", @quote) |> html_response(422)
      assert Repo.all(Inquiry) == []
    end
  end
end
