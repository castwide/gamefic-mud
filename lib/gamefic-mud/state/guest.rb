module Gamefic
  module Mud
    module State
      # A simple introductory state that creates a character with a name
      # provided by the user. MUDs in production should implement a more
      # robust version of authentication, but this is sufficient for testing
      # and development.
      #
      class Guest < Base
        def start
          adapter.send_raw 'Enter your name: '
        end

        def process message
          if message.strip.empty?
            adapter.send_raw "Blank names are not allowed.\r\n"
            start
          else
            character = adapter.plot.make_player_character
            character.name = message.strip
            adapter.character = character
            adapter.start Mud::State::Play
          end
        end
      end
    end
  end
end
