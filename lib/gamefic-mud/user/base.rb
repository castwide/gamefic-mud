module Gamefic
  class Mud::User::Base < Gamefic::User::Base
    attr_accessor :character
    attr_reader :engine

    def initialize connection, engine
      @connection = connection
      @engine = engine
      @state = Mud::User::State::Base.new(self)
    end

    def start user_state
      @state = user_state.new(self)
      @state.start
    end

    def process message
      @state.process message
    end

    def update data
    end

    def transmit data
    end

    def prompt text
    end
  end
end
