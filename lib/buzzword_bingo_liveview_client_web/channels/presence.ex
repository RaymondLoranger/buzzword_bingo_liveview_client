defmodule Buzzword.Bingo.LiveView.ClientWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :buzzword_bingo_liveview_client,
    pubsub_server: Buzzword.Bingo.LiveView.Client.PubSub
end
