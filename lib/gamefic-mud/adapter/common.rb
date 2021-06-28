module Gamefic
  module Mud
    module Adapter
      module Common
        attr_accessor :plot
        attr_accessor :character
        attr_reader :state

        def start user_state
          @state = user_state.new(self)
          @state.start
        end
      end
    end
  end
end
