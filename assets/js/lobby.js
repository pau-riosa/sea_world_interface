
let status = document.querySelector("#status")
let opponentStatus = document.querySelector("#opponent-status")
const game_id = window.game_id
const channel = Object;
const Lobby = {
  init(socket) {
    if (game_id != undefined) {
      const channel = socket.channel("lobby")
      this.joinGame(channel)
      this.newGame(channel, game_id)
      this.playerStatus(channel, game_id)
    }
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
  newGame(channel, game_id) {
    channel.push("new_game", {game_id: game_id})
    .receive("ok", response => {
      console.log("New Game!", response)
    })
    .receive("error", response => {
      console.log("Unable to start a new game.", response)
    })
  },
  playerStatus(channel, game_id) {
      channel.push("opponent_status", {game_id: game_id})
      .receive("ok", response => {
        console.log("checking status...")
      })
      .receive("error", response => {
        console.log("error checking status...")
      })

      channel.on('opponent_status', response => {
        let opponent = response.status ? "Opponent is active" : "No opponent"; 
        let opponentIconStatus = response.status ? " green" : " red"; 
        opponentStatus.innerHTML = opponent;
        status.className += opponentIconStatus 
        console.log("Opponent status", status)
      })  
    }

}
export default Lobby
