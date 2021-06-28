require 'eventmachine'
require 'em-websocket'

module Gamefic
  module Mud
    # The MUD server engine. Responsible for handling client connections and
    # updating the game state.
    #
    class Engine
      # @return [Plot]
      attr_reader :plot

      # @param plot [Plot] The game plot
      # @param start [Class<State::Base>] The initial state for new connections
      # @param interval [Numeric] The number of seconds between updates
      def initialize plot, start: State::Guest, interval: 1
        @plot = plot
        @start = start
        @interval = interval
        @web_connections = {}
        @accepts = []
        @connections = []
      end

      # Tell the engine to run a TCP or WebSocket server.
      #
      # @param type [Symbol] :tcpsocket or :websocket
      # @param host [String] The host name
      # @param port [Integer] The port number
      # @return [void]
      def will_accept type: :tcpsocket, host: '0.0.0.0', port: 4342
        @accepts.push({ type: type, host: host, port: port })
      end

      # Tell the engine to run a TCP server.
      #
      # @param host [String] The host name
      # @param port [Integer] The port number
      # @return [void]
      def will_accept_tcpsocket host: '0.0.0.0', port: 4342
        will_accept type: :tcpsocket, host: host, port: port
      end

      # Tell the engine to run a WebSocket server.
      #
      # @param host [String] The host name
      # @param port [Integer] The port number
      # @return [void]
      def will_accept_websocket host: '0.0.0.0', port: 4343
        will_accept type: :websocket, host: host, port: port
      end

      # Start the engine.
      #
      # @return [void]
      def run
        EM.epoll
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

          EventMachine.add_periodic_timer @interval do
            plot.update
            plot.ready
            @connections.each do |conn|
              next unless conn.character
              conn.update conn.character.output
            end
          end
        end
      end

      # Stop the engine.
      #
      # @return [void]
      def stop
        puts "Terminating server"
        EventMachine.stop
      end

      private

      def start_websocket host:, port:
        EM::WebSocket.run(host: host, port: port) do |ws|
          ws.onopen do |_handshake|
            ws.extend Adapter::Websocket
            ws.plot = plot
            ws.start @start
            @connections.push ws
          end

          # WebSocket messages are handled here because using `receive_data` in
          # the adapter raises character encoding errors.
          ws.onmessage do |msg|
            ws.state.process msg
          end
        end
        puts "WebSocket server started on #{host}:#{port}"
      end

      def start_tcpsocket host:, port:
        EventMachine.start_server host, port, Adapter::Tcp do |conn|
          conn.plot = plot
          conn.start @start
          @connections.push conn
        end

        puts "Telnet server started on #{host}:#{port}"
      end
    end
  end
end
