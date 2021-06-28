module Gamefic
  class Mud::User::WebSocket < Mud::User::Base
    def update data
      transmit data
    end

    def transmit data
      @connection.send data
    end

    def prompt text
      transmit "<label class=\"prompt\">#{text}</label>"
    end
  end
end
