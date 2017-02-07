module Gamefic

  module Mud::User::State

    class Login < Base

      def start
        user.prompt 'Enter your name:'
      end

      def process message
        character = user.engine.plot.make Character, name: message, description: "#{message} is your name."
        character.connect user
        user.character = character
        user.transmit "Welcome, #{message}."
        user.start Mud::User::State::Play
      end
    end

  end
end
