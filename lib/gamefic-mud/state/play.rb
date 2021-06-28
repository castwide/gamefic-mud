module Gamefic
  module Mud
    module State
      class Play < Base
        def start
          adapter.plot.introduce adapter.character
          adapter.update({ messages: adapter.character.messages })
        end

        def process message
          adapter.character.queue.push message unless message == ''
        end
      end
    end
  end
end
