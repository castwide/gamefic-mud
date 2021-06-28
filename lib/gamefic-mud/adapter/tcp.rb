require 'html_to_ansi'

module Gamefic
  module Mud
    module Adapter
      module Tcp
        include Common

        attr_reader :ip_addr
        attr_reader :port

        def post_init
          port, ip = Socket.unpack_sockaddr_in(get_peername)
          @port = port
          @ip_addr = ip
          puts "Connection received from #{ip}:#{port}"
        end

        def receive_data data
          state.process data
        end

        def tell output
          send_data HtmlToAnsi.convert(output[:messages])
        end

        def send_raw data
          send_data data
        end

        def unbind
          puts "Disconnecting from #{ip_addr}:#{port}"
          # @todo Right way to remove player from game?
          plot.destroy character unless character.nil?
        end
      end
    end
  end
end
