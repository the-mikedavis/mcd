defmodule McdWeb.PageControllerTest do
  use McdWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Michael Davis"
  end
end
