defmodule MerstarsComSgWeb.InquiryComponents do
  @moduledoc """
  Pieces of the contact and quote forms: styled fields with inline errors,
  the Cloudflare Turnstile widget, the honeypot and the status notice.
  """
  use Phoenix.Component

  import MerstarsComSgWeb.CoreComponents, only: [translate_error: 1]

  attr :field, Phoenix.HTML.FormField, required: true
  attr :label, :string, required: true
  attr :type, :string, default: "text"
  attr :rest, :global, include: ~w(placeholder rows autocomplete)

  def inquiry_field(%{type: "textarea"} = assigns) do
    ~H"""
    <div>
      <label for={@field.id}>{@label}</label>
      <textarea
        id={@field.id}
        name={@field.name}
        aria-invalid={@field.errors != [] && "true"}
        {@rest}
      >{Phoenix.HTML.Form.normalize_value("textarea", @field.value)}</textarea>
      <.field_errors field={@field} />
    </div>
    """
  end

  def inquiry_field(assigns) do
    ~H"""
    <div>
      <label for={@field.id}>{@label}</label>
      <input
        type={@type}
        id={@field.id}
        name={@field.name}
        value={Phoenix.HTML.Form.normalize_value(@type, @field.value)}
        aria-invalid={@field.errors != [] && "true"}
        {@rest}
      />
      <.field_errors field={@field} />
    </div>
    """
  end

  attr :field, Phoenix.HTML.FormField, required: true

  defp field_errors(assigns) do
    errors = if Phoenix.Component.used_input?(assigns.field), do: assigns.field.errors, else: []
    assigns = assign(assigns, :errors, Enum.map(errors, &translate_error/1))

    ~H"""
    <p :for={msg <- @errors} class="m-field-error">{msg}</p>
    """
  end

  @doc """
  Cloudflare Turnstile widget. Adds a `cf-turnstile-response` token to the
  form, checked server-side by `MerstarsComSg.Turnstile` with the same `action`.
  """
  attr :action, :string, required: true
  attr :error, :string, default: nil

  def turnstile(assigns) do
    assigns = assign(assigns, :site_key, MerstarsComSg.Turnstile.site_key())

    ~H"""
    <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer>
    </script>
    <div class="cf-turnstile" data-sitekey={@site_key} data-action={@action}></div>
    <script>
      // The normal widget is a fixed 300px wide and overflows the form card on
      // phones; use the compact one there. Runs before the async api.js renders it.
      if (window.innerWidth < 480) {
        document.currentScript.previousElementSibling.dataset.size = "compact";
      }
    </script>
    <p :if={@error} class="m-field-error">{@error}</p>
    """
  end

  @doc """
  Hidden from people (off-screen, skipped by keyboard and screen readers);
  bots that fill in every field give themselves away.
  """
  def honeypot(assigns) do
    ~H"""
    <div class="m-honeypot" aria-hidden="true">
      <label for="website">Leave this field empty</label>
      <input type="text" id="website" name="website" tabindex="-1" autocomplete="off" />
    </div>
    """
  end

  @doc "Success or failure message shown above the form after a submission."
  attr :flash, :map, required: true

  def inquiry_notice(assigns) do
    ~H"""
    <p :if={msg = Phoenix.Flash.get(@flash, :info)} class="m-notice m-notice-ok" role="status">
      {msg}
    </p>
    <p :if={msg = Phoenix.Flash.get(@flash, :error)} class="m-notice m-notice-error" role="alert">
      {msg}
    </p>
    """
  end
end
