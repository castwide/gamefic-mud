lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gamefic-mud/version'
require 'date'

Gem::Specification.new do |s|
  s.name          = 'gamefic-mud'
  s.version       = Gamefic::Mud::VERSION
  s.date          = Date.today.strftime("%Y-%m-%d")
  s.summary       = "Gamefic MUD"
  s.description   = "An engine for running multiplayer games with Gamefic"
  s.authors       = ["Fred Snyder"]
  s.email         = 'fsnyder@gamefic.com'
  s.homepage      = 'http://gamefic.com'
  s.license       = 'MIT'

  s.files = ['lib/gamefic-mud.rb'] + Dir['lib/gamefic-mud/**/*.rb']
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.1.0'
  s.add_runtime_dependency 'gamefic'
  s.add_runtime_dependency 'websocket-eventmachine-server', '~> 1.0.1'
end
