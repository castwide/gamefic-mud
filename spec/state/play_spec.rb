describe Gamefic::Mud::State::Play do
  let(:adapter) {
    plot = Gamefic::Plot.new
    plot.introduction do |actor|
      actor.tell "Hello, #{actor}!"
    end
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
    adapter.character = plot.make_player_character
    adapter.character.name = 'Joe'
    adapter
  }

  it 'introduces the character' do
    adapter.start Gamefic::Mud::State::Play
    expect(adapter.character.messages).to include('Hello, Joe!')
  end

  it 'queues a command' do
    adapter.start Gamefic::Mud::State::Play
    adapter.state.process 'do a thing'
    expect(adapter.character.queue).to include('do a thing')
  end
end
