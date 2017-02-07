module Gamefic

  module Mud::User::State

    class Base
      attr_reader :user

      def initialize user
        @user ||= user
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
