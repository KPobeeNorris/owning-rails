require 'spec_helper'

RSpec.describe ActionCable do
  before do
    @server = Thin::Server.new(8082, ActionCable.server)
    Thin::Logging.silent = true

    @thread = Thread.new { @server.start }
    wait_for { @server.running? }

    @websocket = Faye::WebSocket::Client.new("ws://127.0.0.1:8082/?token=valid")
    wait_for { @websocket.ready_state == Faye::WebSocket::Client::OPEN }
  end

  after do
    @server.stop!
    @thread.join
  end

  it 'can subscribe to a channel' do
    connection = ActionCable.server.connections.first
    expect(connection)
    @websocket.send(JSON.dump(command: 'subscribe', channel: 'ChatChannel'))

    wait_for { connection.subscriptions["ChatChannel"] }

    expect(ActionCable.server.pubsub.subscribed?("chat")).to eq true
  end

  it 'can send and receive messages' do
    @websocket.send(JSON.dump(command: 'subscribe', channel: 'ChatChannel'))

    received = nil
    @websocket.on :message do |event|
      received = JSON.parse(event.data)
    end

    @websocket.send(JSON.dump(command: 'message', channel: 'ChatChannel', data: "hello!"))

    wait_for { received }

    expect(received).to eq ({ 'channel' => 'ChatChannel', 'message' => 'hello!'})
  end

  it 'closes the websocket if invalid connection' do
    @websocket = Faye::WebSocket::Client.new("ws://127.0.0.1:8082/?token=invalid")
    wait_for { @websocket.ready_state == Faye::WebSocket::Client::CLOSED }
  end

  def wait_for
    Timeout.timeout 3 do
      Thread.pass until yield
    end
  end
end
