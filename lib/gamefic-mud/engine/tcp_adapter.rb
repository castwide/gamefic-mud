require 'html_to_ansi'

module Gamefic
  module Mud
    class Engine
      module TcpAdapter
        attr_accessor :plot
        attr_accessor :character
        attr_reader :state
        # attr_accessor :user
        attr_reader :ip_addr
        attr_reader :port

        def post_init
          port, ip = Socket.unpack_sockaddr_in(get_peername)
          @port = port
          @ip_addr = ip
          puts "Connection received from #{ip}:#{port}"
        end

        def receive_data data
          # HACK Convert to UTF-8 and close connection on errors
          conv = ''
          data.each_byte do |b|
            c = b.chr.encode('UTF-8')
            if c.valid_encoding?
              conv += c
            else
              conv += '?'
            end
          end
          conv.strip!
          state.process conv
        rescue Encoding::UndefinedConversionError
          puts 'Throwing away garbage'
          close_connection
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

        def start user_state
          @state = user_state.new(self)
          @state.start
        end
      end
    end
  end
end
