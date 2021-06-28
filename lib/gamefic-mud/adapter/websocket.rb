require 'json'

module Gamefic
  module Mud
    module Adapter
      module Websocket
        include Common

        def tell output
          # Websocket connections are assumed to be rich clients. Send them
          # the entire output hash and let them determine how to render the
          # data.
          send output.to_json
        end

        def send_raw data
          tell({messages: data})
        end
      end
    end
  end
end
