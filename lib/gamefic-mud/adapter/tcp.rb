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
          # TCP connections are assumed to be terminal clients. Convert messages and options into
          # an HTML block and convert it to ANSI text.
          text = output[:messages]
          unless output[:options].nil?
            list = '<ol>'
            state[:options].each do |o|
              list += "<li>#{o}</li>"
            end
            list += "</ol>"
            text += list
          end
          # @todo The line endings should probably be a function of HtmlToAnsi.
          send_data HtmlToAnsi.convert(text).gsub(/\n/, "\r\n")
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
