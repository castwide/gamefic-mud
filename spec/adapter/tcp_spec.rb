describe Gamefic::Mud::Adapter::Tcp do
  let(:object) {
    Class.new {
      include Gamefic::Mud::Adapter::Tcp
      attr_writer :state
      attr_reader :received

      def send_data text
        @received = text
      end
    }.new
  }

  it 'receives data' do
    object.state = double(:state)
    expect(object.state).to receive(:process)
    object.receive_data 'input'
  end

  it 'sends messages to clients' do
    object.update({ messages: 'output' })
    expect(object.received).to include('output')
  end

  it 'sends options to clients' do
    object.update({ options: ['one', 'two'] })
    expect(object.received).to include('one')
    expect(object.received).to include('two')
  end
end
