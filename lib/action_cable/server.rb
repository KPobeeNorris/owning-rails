Faye::WebSocket.load_adapter 'thin' if defined? Thin

require "#{Rails.root}/app/channels/application_cable/connection"

module ActionCable
  class Server
    attr_reader :connections, :pubsub

    def initialize
      @connections = []
      @pubsub = SubscriptionAdapter::Inline.new
    end

    def broadcast(name, data)
      @pubsub.broadcast(name, data)
    end

    def call(env)
      connection = ApplicationCable::Connection.new(self, env)
      @connections << connection
      connection.process
    end
  end
end
