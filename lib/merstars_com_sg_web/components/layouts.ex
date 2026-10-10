defmodule MerstarsComSgWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use MerstarsComSgWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="navbar px-4 sm:px-6 lg:px-8">
      <div class="flex-1">
        <a href="/" class="flex-1 flex w-fit items-center gap-2">
          <img src={~p"/images/logo.svg"} width="36" />
          <span class="text-sm font-semibold">v{Application.spec(:phoenix, :vsn)}</span>
        </a>
      </div>
      <div class="flex-none">
        <ul class="flex flex-column px-1 space-x-4 items-center">
          <li>
            <a href="https://phoenixframework.org/" class="btn btn-ghost">Website</a>
          </li>
          <li>
            <a href="https://github.com/phoenixframework/phoenix" class="btn btn-ghost">GitHub</a>
          </li>
          <li>
            <.theme_toggle />
          </li>
          <li>
            <a href="https://hexdocs.pm/phoenix/overview.html" class="btn btn-primary">
              Get Started <span aria-hidden="true">&rarr;</span>
            </a>
          </li>
        </ul>
      </div>
    </header>

    <main class="px-4 py-20 sm:px-6 lg:px-8">
      <div class="mx-auto max-w-2xl space-y-4">
        {render_slot(@inner_block)}
      </div>
    </main>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @nav_items [
    {"/", "Home", :home},
    {"/about-us", "About Us", :about},
    {"/our-network", "Our Network", :network},
    {"/services", "Services", :services},
    {"/team", "Our Team", :team},
    {"/partnership", "Partnership", :partnership},
    {"/contact-us", "Contact Us", :contact}
  ]

  @doc """
  Marketing site chrome: utility top bar, main nav, and footer.
  Pass `current_page` (an atom from the nav item list) to highlight the active link.
  """
  attr :current_page, :atom, default: nil
  slot :inner_block, required: true

  def marketing(assigns) do
    assigns = assign(assigns, :nav_items, @nav_items)

    ~H"""
    <div class="merstar">
      <div class="m-topbar">
        <div class="m-topbar-inner">
          <div>
            <a href="mailto:sales@merstar.com.sg">sales@merstar.com.sg</a>
            &nbsp;·&nbsp;
            <a href="tel:+6565458833">(65) 6545-8833</a>
          </div>
          <div><span class="m-signal-dot">●</span> Member, L.I.N.K Global Network</div>
        </div>
      </div>

      <nav class="m-nav">
        <div class="m-nav-inner">
          <a href="/" class="m-brand">
            <img src={~p"/images/merstar-logo.png"} alt="Merstar International" class="m-brand-mark" />
            <span class="m-brand-word">
              Merstar International
              <small>FREIGHT &amp; LOGISTICS · EST. 1989</small>
            </span>
          </a>
          <div class="m-navlinks">
            <%= for {path, label, key} <- @nav_items do %>
              <a href={path} class={if @current_page == key, do: "current"}>{label}</a>
            <% end %>
          </div>
          <div class="m-nav-actions">
            <a href="/request-for-quote" class="m-btn m-btn-primary">Request a Quote</a>
            <button
              type="button"
              class="m-nav-burger"
              aria-label="Toggle menu"
              aria-expanded="false"
              aria-controls="m-mobile-menu"
              phx-click={
                JS.toggle_attribute({"hidden", "hidden"}, to: "#m-mobile-menu")
                |> JS.toggle_attribute({"aria-expanded", "true", "false"})
                |> JS.toggle_class("is-open")
              }
            >
              <span></span><span></span><span></span>
            </button>
          </div>
        </div>
        <div id="m-mobile-menu" class="m-mobile-menu" hidden>
          <%= for {path, label, key} <- @nav_items do %>
            <a href={path} class={if @current_page == key, do: "current"}>{label}</a>
          <% end %>
        </div>
      </nav>
      <div class="m-nav-gradient-rule"></div>

      {render_slot(@inner_block)}

      <footer class="m-footer">
        <div class="m-container">
          <div class="m-footer-cols">
            <div>
              <h4>Merstar International</h4>
              <p>
                7 Airline Road #02-09<br />Cargo Agents Building E<br />
                Changi Airfreight Centre, Singapore 819834
              </p>
            </div>
            <div>
              <h4>Services</h4>
              <a href="/services">Airfreight</a>
              <a href="/services">Ocean Freight</a>
              <a href="/services">Transportation</a>
              <a href="/services">Customs Clearance</a>
            </div>
            <div>
              <h4>Company</h4>
              <a href="/about-us">About Us</a>
              <a href="/our-network">Our Network</a>
              <a href="/partnership">Partnership</a>
              <a href="/contact-us">Contact</a>
            </div>
            <div>
              <h4>Contact</h4>
              <a href="mailto:sales@merstar.com.sg">sales@merstar.com.sg</a>
              <a href="tel:+6565458833">Main (65) 6545-8833</a>
              <a href="tel:+6565458266">Sales (65) 6545-8266</a>
              <a href="tel:+6565432663">Ops (65) 6543-2663</a>
            </div>
          </div>
          <div class="m-footer-bottom">
            <span>© 2026 Merstar International (Singapore) Pte Ltd · UEN 198901368N</span>
            <span>IATA · FIATA · SAAA · ISO Certified</span>
          </div>
        </div>
      </footer>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end
