defmodule Buzzword.Bingo.Liveview.ClientWeb.PageController do
  use Buzzword.Bingo.Liveview.ClientWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
