defmodule SeaWorldInterfaceWeb.ChannelController do
  use SeaWorldInterfaceWeb, :controller

  alias SeaWorldInterface.{Repo, SeaWorld}
  alias SeaWorldInterface.SeaWorld.{Channel, Player1, Player2}

  def index(conn, _params) do
    channels = SeaWorld.list_channels()
    render(conn, "index.html", channels: channels)
  end

  def new(conn, _params) do
    changeset = SeaWorld.change_channel(%Channel{player1: %Player1{}})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"channel" => channel_params}) do
    case SeaWorld.create_channel(channel_params) do
      {:ok, channel} ->
        conn
        |> put_flash(:info, "Channel created successfully.")
        |> redirect(to: Routes.channel_path(conn, :show, channel))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    channel =
      SeaWorld.get_channel!(id)
      |> Repo.preload([:player1, :player2])

    id =
      4
      |> :crypto.strong_rand_bytes()
      |> Base.url_encode64()

    render(conn, "show.html", channel: channel, player_id: id)
  end

  def edit(conn, %{"id" => id}) do
    channel =
      SeaWorld.get_channel!(id)
      |> Repo.preload([:player1, :player2])

    changeset = SeaWorld.change_channel(channel)
    render(conn, "edit.html", channel: channel, changeset: changeset)
  end

  def update(conn, %{"id" => id, "channel" => channel_params}) do
    channel =
      SeaWorld.get_channel!(id)
      |> Repo.preload([:player1, :player2])

    case SeaWorld.update_channel(channel, channel_params) do
      {:ok, channel} ->
        conn
        |> put_flash(:info, "Channel updated successfully.")
        |> redirect(to: Routes.channel_path(conn, :show, channel))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", channel: channel, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    channel = SeaWorld.get_channel!(id)
    {:ok, _channel} = SeaWorld.delete_channel(channel)

    conn
    |> put_flash(:info, "Channel deleted successfully.")
    |> redirect(to: Routes.channel_path(conn, :index))
  end
end
