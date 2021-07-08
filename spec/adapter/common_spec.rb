describe Gamefic::Mud::Adapter::Common do
  let(:adapter) do
    obj = Object.new
    obj.extend Gamefic::Mud::Adapter::Common
    obj
  end

  it 'starts a state' do
    adapter.start Gamefic::Mud::State::Base
    expect(adapter.state).to be_a(Gamefic::Mud::State::Base)
  end
end
