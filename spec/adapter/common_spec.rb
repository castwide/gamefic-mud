describe Gamefic::Mud::Adapter::Common do
  let(:object) do
    obj = Object.new
    obj.extend Gamefic::Mud::Adapter::Common
    obj
  end

  it 'starts a state' do
    object.start Gamefic::Mud::State::Base
    expect(object.state).to be_a(Gamefic::Mud::State::Base)
  end
end
