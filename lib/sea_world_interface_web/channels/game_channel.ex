defmodule SeaWorldInterfaceWeb.GameChannel do
  use SeaWorldInterfaceWeb, :channel

  alias SeaWorldEngine.{Game, GameSupervisor}

  def join("game:chat", _payload, socket) do
    {:ok, socket}
  end

  def join("game:" <> id, _payload, socket) do
    player_id = socket.assigns.player_id
    state = get_state(socket)

    cond do
      state.penguin.name != nil && state.whale.name != nil ->
        {:error, %{reason: "No more players allowed"}}

      state.penguin.name == player_id ->
        {:error, %{reason: "Waiting for players."}}

      state.whale.name == player_id ->
        {:error, %{reason: "Waiting for players."}}

      true ->
        add_player(state, via(socket.topic), player_id, socket)
    end
  end

  def join("game:" <> _id, _payload, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_message", %{"message" => message} = _payload, socket) do
    broadcast!(socket, "show_message", %{message: message, player_id: socket.assigns.player_id})
    {:noreply, socket}
  end

  defp add_player(%{rules: %{state: :waiting_for_player}} = state, game, player_id, socket) do
    Game.add_player_whale(game, player_id)
    {:ok, assign(socket, :game, game)}
  end

  defp add_player(%{rules: %{state: :initialized}} = _state, game, player_id, socket) do
    Game.add_player_penguin(game, player_id)
    {:ok, assign(socket, :game, game)}
  end

  defp add_player(_state, _game, _player_id, socket),
    do: {:ok, socket}

  # get registry of state 
  defp via("game:" <> game_id), do: Game.via_tuple(game_id)

  # # get state of the game
  defp get_state(socket) do
    socket.topic
    |> via()
    |> :sys.get_state()
  end

  # @doc """
  # add penguin player 
  # """
  # def handle_in("add_player_penguin", %{"player" => player} = _payload, socket) do
  #   case Game.add_player_penguin(via(socket.topic), player) do
  #     :ok ->
  #       broadcast!(socket, "penguin_added", %{
  #         message: "New player just joined (as penguin): " <> player,
  #         player: player
  #       })

  #       send(self(), :check_state)
  #       {:noreply, socket}

  #     {:error, reason} ->
  #       {:reply, {:error, %{reason: inspect(reason)}}, socket}

  #     :error ->
  #       {:reply, :error, socket}
  #   end
  # end

  # @doc """
  # add whale player 
  # """
  # def handle_in("add_player_whale", %{"player" => player} = _payload, socket) do
  #   case Game.add_player_whale(via(socket.topic), player) do
  #     :ok ->
  #       broadcast!(socket, "whale_added", %{
  #         message: "New player just joined (as whale): " <> player,
  #         player: player
  #       })

  #       send(self(), :check_state)
  #       {:noreply, socket}

  #     {:error, reason} ->
  #       {:reply, {:error, %{reason: inspect(reason)}}, socket}

  #     :error ->
  #       {:reply, :error, socket}
  #   end
  # end

  # @doc """
  # add a new game via channel id
  # """
  # def handle_in("new_game", _payload, socket) do
  #   "game:" <> game_id = socket.topic

  #   case GameSupervisor.start_game(game_id) do
  #     {:ok, _pid} ->
  #       send(self(), :check_state)
  #       {:reply, :ok, socket}

  #     {:error, {:already_started, _pid}} ->
  #       send(self(), :check_state)
  #       Process.sleep(2000)
  #       send(self(), :assign)
  #       {:reply, {:error, %{reason: "Game already started."}}, socket}

  #     {:error, reason} ->
  #       {:reply, {:error, %{reason: inspect(reason)}}, socket}
  #   end
  # end

  # def handle_info(:check_state, socket) do
  #   socket
  #   |> get_state()
  #   |> do_check_state(socket)

  #   {:noreply, socket}
  # end

  # def handle_info(:assign, socket) do
  #   socket
  #   |> get_state()
  #   |> do_assign(socket)
  # end

  # def handle_info(:set_creatures, socket) do
  #   game =
  #     socket.topic
  #     |> via

  #   Game.set_creatures(game, :penguin)
  #   Game.set_creatures(game, :whale)

  #   broadcast!(socket, "set_creatures", %{message: "creatures are set."})
  #   {:noreply, socket}
  # end

  # def handle_info(:position_creature, socket) do
  #   game =
  #     socket.topic
  #     |> via

  #   Enum.each(1..8, fn x ->
  #     row = Enum.random(1..10)
  #     col = Enum.random(1..15)
  #     Game.position_creature(game, :whale, :whale, row, col)
  #     IO.puts(x)
  #   end)

  #   Enum.each(1..12, fn x ->
  #     row = Enum.random(1..10)
  #     col = Enum.random(1..15)
  #     Game.position_creature(game, :penguin, :penguin, row, col)
  #     IO.puts(x)
  #   end)

  #   broadcast!(socket, "position_creature", %{message: "creatures positioned."})
  #   {:noreply, socket}
  # end

  # def handle_info(:render_board, socket) do
  #   board =
  #     Phoenix.View.render_to_string(SeaWorldInterfaceWeb.ChannelView, "_board.html", %{
  #       message: "message",
  #       row: 1..10,
  #       col: 1..15,
  #       field_size: 30
  #     })

  #   broadcast!(socket, "render_board", %{board: board})
  #   {:noreply, socket}
  # end

  # def do_check_state(%{rules: %{state: :penguin_turn}} = state, socket),
  #   do: broadcast!(socket, "game_state", %{state: "penguin turn."})

  # def do_check_state(%{rules: %{state: :players_set}} = state, socket) do
  #   broadcast!(socket, "game_state", %{state: "all players set."})
  #   send(self(), :position_creature)
  #   send(self(), :set_creatures)
  # end

  # def do_check_state(%{rules: %{state: :waiting_for_players}} = _state, socket),
  #   do: broadcast!(socket, "game_state", %{state: "waiting_for_players..."})

  # def do_check_state(_state, socket),
  #   do: broadcast!(socket, "game_state", %{state: "initializing game..."})

  # def do_assign(state, socket) do
  #   send(self(), :render_board)
  #   broadcast!(socket, "reassign_penguin", %{penguin: state.penguin.name})
  #   broadcast!(socket, "reassign_whale", %{whale: state.whale.name})
  #   {:noreply, socket}
  # end
end
