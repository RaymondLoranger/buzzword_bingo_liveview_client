defmodule Buzzword.Bingo.LiveView.ClientWeb.PageController do
  use Buzzword.Bingo.LiveView.ClientWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
