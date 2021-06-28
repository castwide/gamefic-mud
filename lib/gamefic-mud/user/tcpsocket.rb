require 'gamefic/text'

module Gamefic
  class Mud::User::TcpSocket < Mud::User::Base
    def update data
      transmit "\n" + Gamefic::Text::Html::Conversions.html_to_ansi(data)
    end

    def transmit data
      @connection.send_data data
    end

    def prompt text
      transmit "\n#{text} "
    end
  end
end
