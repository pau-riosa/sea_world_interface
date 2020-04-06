const messagesContainer = document.querySelector("#messages")
const send_message = document.querySelector("#send-message")

const Chat = {
  init(socket) {
    const channel = socket.channel("game:chat")
    channel.join()
    this.listenForChats(channel)
  },
  listenForChats(game_chat) {
    send_message.addEventListener("keypress", (e) => {
      if (e.keyCode == 13) {
        game_chat.push("new_message", {message: send_message.value})
        .receive("ok", response => {
          console.log(" message", response)
        })
        .receive("error", response => {
          console.log("unable to send message", response) 
        })
        send_message.value = "";
      }
      })

    game_chat.on("show_message", response => {
      const row_class = response.player_id == window.player_id ?  "mine" : "not-mine";
      const message_row = document.createElement("li")
      message_row.className = row_class
      message_row.insertAdjacentHTML("beforeend", response.message)
      messagesContainer.appendChild(message_row)
      messagesContainer.scrollTop = messages.scrollHeight;
      console.log("new message", response)
    })
  },
} 
export default Chat 
