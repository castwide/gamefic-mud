module Gamefic
  module Mud
    module State
      class Play < Base
        def start
          user.plot.introduce user.character
          user.tell({ messages: user.character.messages })
        end

        def process message
          user.character.queue.push message unless message == ''
        end
      end
    end
  end
end
