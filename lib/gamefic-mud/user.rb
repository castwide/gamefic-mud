module Gamefic
  module Mud::User
    autoload :Base, 'gamefic-mud/user/base'
    autoload :State, 'gamefic-mud/user/state'
    autoload :WebSocket, 'gamefic-mud/user/websocket'
    autoload :TcpSocket, 'gamefic-mud/user/tcpsocket'
  end
end
