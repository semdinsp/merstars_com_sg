defmodule MerstarsComSgWeb.PageController do
  use MerstarsComSgWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def about(conn, _params) do
    render(conn, :about)
  end

  def network(conn, _params) do
    render(conn, :network)
  end

  def services(conn, _params) do
    render(conn, :services)
  end

  def team(conn, _params) do
    render(conn, :team)
  end

  def request_quote(conn, _params) do
    render(conn, :request_quote)
  end

  def partnership(conn, _params) do
    render(conn, :partnership)
  end

  def contact(conn, _params) do
    render(conn, :contact)
  end

  def privacy(conn, _params) do
    render(conn, :privacy)
  end
end
