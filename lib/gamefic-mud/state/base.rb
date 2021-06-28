module Gamefic
  module Mud
    module State
      # An abstract class for handling client states.
      #
      class Base
        # @return [Adapter::Common]
        attr_reader :adapter

        # @param adapter [Adapter::Common]
        def initialize adapter
          @adapter = adapter
        end

        # Called when a client's state changes.
        # Subclasses should implement this method.
        #
        # @return [void]
        def start
          puts "User started #{self.class}"
        end

        # Called when a message is received from a client.
        # Subclasses should implement this method.
        #
        # @param message [String]
        # @return [void]
        def process message
          puts "User sent #{message} in #{self.class}"
        end
      end
    end
  end
end
