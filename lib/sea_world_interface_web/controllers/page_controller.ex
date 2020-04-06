defmodule SeaWorldInterfaceWeb.PageController do
  use SeaWorldInterfaceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
