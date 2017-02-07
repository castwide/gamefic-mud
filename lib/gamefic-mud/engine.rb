require 'websocket-eventmachine-server'

module Gamefic

  class Mud::Engine < Gamefic::Engine::Base
    def post_initialize
      @web_connections = {}
      @accepts = []
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
      EM.epoll
      EM.run do
        trap("TERM") { stop }
        trap("INT")  { stop }
        
        if @accepts.empty?
          will_accept
        end
        @accepts.each { |a|
          if a[:type] == :websocket
            start_websocket host: a[:host], port: a[:port]
          else
            start_tcpsocket host: a[:host], port: a[:port]
          end
        }

        EventMachine.add_periodic_timer 1 do
          plot.ready
          plot.update
          plot.players.each { |p|
            data = p.user.flush
            if data != ''
              p.user.update data
              p.user.prompt p.prompt
            end
          }
        end
      end

    end

    def stop
      puts "Terminating WebSocket Server"
      EventMachine.stop
    end

    private

    def start_websocket host:, port:
      ::WebSocket::EventMachine::Server.start(host: host, port: port) do |ws|

        ws.onopen do
          puts "Client connected"
          user = Gamefic::Mud::User::WebSocket.new(ws, self)
          user.start Mud::User::State::Login
          @web_connections[ws] = user
        end

        ws.onmessage do |msg, type|
          @web_connections[ws].process msg
        end

        ws.onclose do
          puts "Client disconnected"
          plot.destroy @web_connections[ws].character unless @web_connections[ws].character.nil?
          @web_connections.delete ws
        end

        ws.onerror do |e|
          puts "Error: #{e}"
        end

        ws.onping do |msg|
          puts "Received ping: #{msg}"
        end

        ws.onpong do |msg|
          puts "Received pong: #{msg}"
        end

      end

      puts "WebSocket server started on #{host}:#{port}"
    end

    module TcpHandler
      attr_accessor :plot
      attr_accessor :user
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
        data.each_byte { |b|
          c = b.chr.encode('UTF-8')
          if c.valid_encoding?
            conv += c
          else
            conv += '?'
          end
        }
        conv.strip!
        user.process conv
      rescue Encoding::UndefinedConversionError
        puts 'Throwing away garbage'
        close_connection
      end
      def unbind
        puts "Disconnecting from #{ip_addr}:#{port}"
        plot.destroy user.character unless user.character.nil?
      end
    end

    def start_tcpsocket host:, port:
      EventMachine.start_server host, port, TcpHandler do |conn|
        conn.plot = plot
        conn.user = Gamefic::Mud::User::TcpSocket.new(conn, self)
        conn.user.start Mud::User::State::Login
      end

      puts "Telnet server started on #{host}:#{port}"
    end
  end

end
