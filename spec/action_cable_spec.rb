require 'spec_helper'

RSpec.describe ActionCable do
  before do
    @server = Thin::Server.new(8082, ActionCable.server)
    Thin::Logging.silent = true

    @thread = Thread.new { @server.start }
    wait_for { @server.running? }

    @websocket = Faye::WebSocket::Client.new("ws://127.0.0.1:8082/")
    wait_for { @websocket.ready_state == Faye::WebSocket::Client::OPEN }
  end

  after do
    @server.stop!
    @thread.join
  end

  it 'tests subscribe' do
    connection = ActionCable.server.connections.first
    expect(connection)
  end

  def wait_for
    Timeout.timeout 3 do
      Thread.pass until yield
    end
  end
end
