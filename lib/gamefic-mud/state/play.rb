module Gamefic
  module Mud
    module State
      # The typical gameplay handler. This state processes client messages as
      # commands to be executed by the player's character.
      #
      class Play < Base
        def start
          adapter.plot.introduce adapter.character
          # Since the game is already running when the player connects, the
          # plot update flushes messages received in the introduction. We're
          # working around the problem by sending them here.
          adapter.update({ messages: adapter.character.messages })
        end

        def process message
          adapter.character.queue.push message unless message == ''
        end
      end
    end
  end
end
