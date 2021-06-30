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
end
