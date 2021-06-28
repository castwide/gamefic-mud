module Gamefic
  module Mud
    module Adapter
      # Common attributes and methods of client adapters.
      #
      module Common
        # @return [Plot]
        attr_accessor :plot

        # @return [Actor]
        attr_accessor :character

        # @return [State::Base]
        attr_reader :state

        # @param state [Class<State::Base>]
        # @return [void]
        def start state
          @state = state.new(self)
          @state.start
        end

        # @!method send_raw(data)
        #   Send raw data to the client outside of the game.
        #   Normally, game-related data is sent through the character,
        #   usually via `character#tell` or `character#stream`. `#raw_data`
        #   allows the engine to communicate with the client outside of the
        #   game proper, e.g., to display a login prompt.
        #
        #   Adapters should implement this method.
        #
        #   @abstract
        #   @param data [String] The message text
        #   @return [void]

        # @!method update(output)
        #   Send a game update to the client. The engine uses this method to
        #   broadcast messages and provide data about the current game state.
        #
        #   Adapters should implement this method.
        #
        #   @abstract
        #   @param output [Hash]
        #   @return [void]
      end
    end
  end
end
