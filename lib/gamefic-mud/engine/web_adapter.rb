# @todo Moved from Engine. Make it work

module Gamefic
  module Mud
    class Engine
      module WebAdapter
        attr_accessor :plot
        attr_accessor :character
        attr_reader :state

        def start user_state
          @state = user_state.new(self)
          @state.start
        end

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
