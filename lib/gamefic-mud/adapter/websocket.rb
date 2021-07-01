require 'json'

module Gamefic
  module Mud
    module Adapter
      # The WebSocket client adapter module.
      #
      module Websocket
        include Common

        # @param output [Hash]
        # @return [void]
        def update output
          # Websocket connections are assumed to be rich clients. Send them
          # the entire output hash and let them determine how to render the
          # data.
          send output.to_json
        end

        # @param data [String]
        # @return [void]
        def send_raw data
          # Convert raw text to a hash with a `messages` key so the WebSocket
          # client can rely on a single standard for incoming data.
          update({messages: data})
        end
      end
    end
  end
end
