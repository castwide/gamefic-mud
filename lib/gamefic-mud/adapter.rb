module Gamefic
  module Mud
    module Adapter
      autoload :Common, 'gamefic-mud/adapter/common'
      autoload :Tcp, 'gamefic-mud/adapter/tcp'
      autoload :Websocket, 'gamefic-mud/adapter/websocket'
    end
  end
end
