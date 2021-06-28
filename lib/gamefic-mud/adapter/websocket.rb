# @todo Moved from Engine. Make it work

module Gamefic
  module Mud
    module Adapter
      module Websocket
        include Common

        def tell output
          send output[:messages]
        end

        def send_raw data
          send data
        end
      end
    end
  end
end
