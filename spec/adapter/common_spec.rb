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

  it 'stores session data' do
    adapter.session[:one] = 1
    expect(adapter.session[:one]).to eq(1)
    expect(adapter[:one]).to eq(1)
    adapter[:two] = 2
    expect(adapter[:two]).to eq(2)
  end
end
