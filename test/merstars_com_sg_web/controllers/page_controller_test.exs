defmodule MerstarsComSgWeb.PageControllerTest do
  use MerstarsComSgWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Your partnership"
  end

  test "GET /about-us", %{conn: conn} do
    conn = get(conn, ~p"/about-us")
    assert html_response(conn, 200) =~ "Merger of Stars"
  end

  test "GET /our-network", %{conn: conn} do
    conn = get(conn, ~p"/our-network")
    assert html_response(conn, 200) =~ "We connect the world"
  end

  test "GET /services", %{conn: conn} do
    conn = get(conn, ~p"/services")
    assert html_response(conn, 200) =~ "Airfreight"
  end

  test "GET /partnership", %{conn: conn} do
    conn = get(conn, ~p"/partnership")
    assert html_response(conn, 200) =~ "Partnership"
  end

  test "GET /contact-us", %{conn: conn} do
    conn = get(conn, ~p"/contact-us")
    assert html_response(conn, 200) =~ "sales@merstar.com.sg"
  end

  test "GET /team", %{conn: conn} do
    conn = get(conn, ~p"/team")
    assert html_response(conn, 200) =~ "Ronnie See"
  end

  test "GET /request-for-quote", %{conn: conn} do
    conn = get(conn, ~p"/request-for-quote")
    assert html_response(conn, 200) =~ "Request Quote"
  end
end
