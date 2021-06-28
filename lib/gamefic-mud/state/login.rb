module Gamefic
  module Mud
    module State
      class Login < Base
        def start
          adapter.send_raw 'Enter your name:'
        end

        def process message
          character = adapter.plot.make_player_character
          character.name = message.strip
          adapter.character = character
          adapter.start Mud::State::Play
        end
      end
    end
  end
end
