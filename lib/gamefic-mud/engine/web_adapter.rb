# @todo Moved from Engine. Make it work

::WebSocket::EventMachine::Server.start(host: host, port: port) do |ws|

  ws.onopen do
    puts "Client connected"
    user = Gamefic::Mud::User::WebSocket.new(ws, self)
    user.start Mud::User::State::Login
    @web_connections[ws] = user
  end

  ws.onmessage do |msg, type|
    @web_connections[ws].process msg
  end

  ws.onclose do
    puts "Client disconnected"
    plot.destroy @web_connections[ws].character unless @web_connections[ws].character.nil?
    @web_connections.delete ws
  end

  ws.onerror do |e|
    puts "Error: #{e}"
  end

  ws.onping do |msg|
    puts "Received ping: #{msg}"
  end

  ws.onpong do |msg|
    puts "Received pong: #{msg}"
  end

end

puts "WebSocket server started on #{host}:#{port}"
