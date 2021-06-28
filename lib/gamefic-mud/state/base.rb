module Gamefic
  module Mud
    module State
      class Base
        attr_reader :adapter

        def initialize adapter
          @adapter = adapter
        end

        def start
          puts "User started #{self.class}"
        end

        def process message
          puts "User sent #{message} in #{self.class}"
        end
      end
    end
  end
end
