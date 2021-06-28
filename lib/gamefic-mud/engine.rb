require 'websocket-eventmachine-server'
require 'html_to_ansi'

module Gamefic
  module Mud
    class Engine
      autoload :TcpAdapter, 'gamefic-mud/engine/tcp_adapter'

      attr_reader :plot

      def initialize plot
        @plot = plot
        @web_connections = {}
        @accepts = []
        @connections = []
      end

      def will_accept type: :tcpsocket, host: '0.0.0.0', port: 4342
        @accepts.push({ type: type, host: host, port: port })
      end

      def will_accept_tcpsocket host: '0.0.0.0', port: 4342
        will_accept type: :tcpsocket, host: host, port: port
      end

      def will_accept_websocket host: '0.0.0.0', port: 4343
        will_accept type: :websocket, host: host, port: port
      end

      def run
        # EM.epoll
        EM.run do
          trap("TERM") { stop }
          trap("INT")  { stop }

          # Start a default TCP server if none are configured
          will_accept if @accepts.empty?

          @accepts.each do |a|
            if a[:type] == :websocket
              start_websocket host: a[:host], port: a[:port]
            else
              start_tcpsocket host: a[:host], port: a[:port]
            end
          end

          EventMachine.add_periodic_timer 1 do
            plot.update
            plot.ready
            @connections.each do |conn|
              next unless conn.character
              conn.send_data HtmlToAnsi.convert(conn.character.output[:messages]).gsub(/\n/, "\r\n")
            end
          end
        end
      end

      def stop
        puts "Terminating server"
        EventMachine.stop
      end

      private

      def start_websocket host:, port:
        # @todo Start the websocket server
        raise "WebSocket server not implemented"
      end

      def start_tcpsocket host:, port:
        EventMachine.start_server host, port, TcpAdapter do |conn|
          conn.plot = plot
          conn.start Mud::State::Login
          @connections.push conn
        end

        puts "Telnet server started on #{host}:#{port}"
      end
    end
  end
end
