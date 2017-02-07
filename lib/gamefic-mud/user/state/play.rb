module Gamefic

  class Mud::User::State::Play < Mud::User::State::Base
    def start
      user.engine.plot.introduce user.character
    end

    def process message
      user.character.queue.push message unless message == ''
    end
  end

end
