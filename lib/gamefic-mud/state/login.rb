module Gamefic
  module Mud
    module State
      class Login < Base
        def start
          user.send_data 'Enter your name:'
        end

        def process message
          character = user.plot.make_player_character
          character.name = message.strip
          user.character = character
          user.character.tell "Welcome, #{character.name}"
          user.start Mud::User::State::Play
        end
      end
    end
  end
end
