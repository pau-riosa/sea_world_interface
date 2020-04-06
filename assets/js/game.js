let game_id = window.game_id
let channel = Object;
let Game = {
  init(socket) {
    channel = socket.channel(`game:${game_id}`)
    this.joinGame(channel)
  },
  joinGame(channel) {
    channel.join()
    .receive("ok", response => {
      console.log("Joined successfully")
    })
  .receive("error", response => {
      console.log("Unable to start a new game.", response)
    })
  },
}

export default Game
