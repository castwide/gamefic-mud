require 'net/telnet'

describe Gamefic::Mud::Engine do
  it 'runs and stops' do
    expect {
      plot = Gamefic::Plot.new
      plot.on_update do
        EventMachine.stop
      end
      engine = Gamefic::Mud::Engine.new(plot)
      engine.will_accept_tcpsocket
      engine.will_accept_websocket
      engine.run
    }.not_to raise_error
  end

  it 'accepts TCP connections' do
    plot = Gamefic::Plot.new
    engine = Gamefic::Mud::Engine.new(plot)
    engine.will_accept_tcpsocket
    Thread.new { engine.run }
    expect {
      Net::Telnet.new('Host' => 'localhost', 'Port' => 4342)
      sleep 2 # Wait for the interval to run
    }.not_to raise_error
    engine.stop
  end
end
