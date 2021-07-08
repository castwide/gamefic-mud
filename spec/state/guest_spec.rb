describe Gamefic::Mud::State::Guest do
  let(:adapter) {
    plot = Gamefic::Plot.new
    adapter = Object.new
    adapter.define_singleton_method :send_raw do |data|
      @sent_raw = data
    end
    adapter.define_singleton_method :update do |output|
      @updated = output
    end
    adapter.define_singleton_method :sent_raw do
      @sent_raw
    end
    adapter.define_singleton_method :updated do
      @updated
    end
    adapter.extend Gamefic::Mud::Adapter::Common
    adapter.plot = plot
    adapter
  }

  it 'prompts for a name' do
    adapter.start Gamefic::Mud::State::Guest
    expect(adapter.sent_raw).to include('Enter your name:')
  end

  it 'requires a name' do
    adapter.start Gamefic::Mud::State::Guest
    adapter.state.process ''
    expect(adapter.state).to be_a(Gamefic::Mud::State::Guest)
  end

  it 'creates a named character' do
    adapter.start Gamefic::Mud::State::Guest
    adapter.state.process 'Joe'
    expect(adapter.character.name).to eq('Joe')
  end

  it 'proceeds to the Play state' do
    adapter.start Gamefic::Mud::State::Guest
    adapter.state.process 'Joe'
    expect(adapter.state).to be_a(Gamefic::Mud::State::Play)
  end
end
