defmodule SeaWorldInterfaceWeb.LobbyChannel do
  use SeaWorldInterfaceWeb, :channel

  alias SeaWorldEngine.{Game, GameSupervisor}

  def join("lobby", _payload, socket) do
    {:ok, socket}
  end

  @doc """
  add a new game via channel id
  """
  def handle_in("opponent_status", %{"game_id" => game_id}, socket) do
    player_id = socket.assigns.player_id

    state =
      game_id
      |> Game.via_tuple()
      |> :sys.get_state()

    cond do
      state.penguin.name != nil && state.whale.name != nil ->
        broadcast!(socket, "opponent_status", %{"status" => "true"})

      state.penguin.name == player_id ->
        broadcast!(socket, "opponent_status", %{"status" => "true"})

      state.whale.name == player_id ->
        broadcast!(socket, "opponent_status", %{"status" => "true"})

      true ->
        broadcast!(socket, "opponent_status", %{"status" => "false"})
    end

    {:noreply, socket}
  end

  @doc """
  add a new game via channel id
  """
  def handle_in("new_game", %{"game_id" => game_id} = _payload, socket) do
    case GameSupervisor.start_game(game_id) do
      {:ok, _pid} ->
        {:reply, {:ok, %{game_id: game_id}}, socket}

      {:error, {:already_started, _pid}} ->
        {:reply, {:error, %{reason: "Game initialized."}}, socket}

      {:error, reason} ->
        {:reply, {:error, %{reason: inspect(reason)}}, socket}
    end
  end
end
