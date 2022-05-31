import Config

config :buzzword_bingo_liveview_client,
  player_colors: [
    "#a4deff",
    "#f9cedf",
    "#d3c5f1",
    "#acc9f5",
    "#aeeace",
    "#96d7b9",
    "#fce8bd",
    "#fcd8ac"
  ]

config :buzzword_bingo_liveview_client, game_sizes: 3..5
config :buzzword_bingo_liveview_client, max_players: 4
