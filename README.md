# Gamefic MUD

A multiplayer engine for [Gamefic](https://github.com/castwide/gamefic-sdk).

[MUDs](https://en.wikipedia.org/wiki/MUD) are multiplayer real-time text games, named after the original [MUD1](https://en.wikipedia.org/wiki/MUD1) by Roy Trubshaw and Richard Bartle. The acronym originally stood for Multi-User Dungeon in tribute to an early variation of the [Zork](https://en.wikipedia.org/wiki/Zork) text adventure. As other MUDs expanded into different genres and game styles, the acronym was expanded to include Multi-User Dimensions or Multi-User Domains.

Much like the original MUD1 introduced a multiplayer version of Zork, Gamefic MUD makes it possible to develop multiplayer versions of Gamefic projects.

## Features

- Tick-based engine simulates real-time gameplay
- Support for connections over TCP (text terminals) or WebSockets
- Engine can easily import most Gamefic projects

## Installation

Install the gem from the command line:

    gem install gamefic-mud

Or add it to your Gemfile:

    gem 'gamefic-mud'

## Hello, World!

This script starts a MUD server for a placeholder game that welcomes the player to the game world:

```ruby
require 'gamefic-mud'

Gamefic.script do
  introduction do |actor|
    actor.tell "Hello, #{actor.name}!"
  end
end

plot = Gamefic::Plot.new

engine = Gamefic::Mud::Engine.start(plot)
```

To connect to the game, telnet to `localhost:4342`.

## Turning a Gamefic Project into a MUD

For testing and development purposes, this is the easiest way to convert your Gamefic project into multiplayer:

* Add `gamefic-mud` to the project's Gemfile and run `bundle install`
* Create a `server.rb` script in the project's root directory:

  ```ruby
  # server.rb

  require 'bundler/setup'
  require 'gamefic-mud'
  require_relative 'main'

  plot = Gamefic::Plot.new

  Gamefic::Mud::Engine.start(plot)
  ```
* Run `ruby server.rb` and telnet to `localhost:4342`

## Running on WebSockets

You can tell the engine to run on WebSockets with the `will_accept_websocket` method:

```ruby
Gamefic::Mud::Engine.start(plot) do
engine.will_accept_websocket
end
```

The default websocket endpoint is `ws://localhost:4343`.

## WebSocket Client Example

This is a barebones example of a web page that can connect to Gamefic MUDs over WebSockets:

```html
<!DOCTYPE html>
<html>
  <head>
    <script>
      function init() {
        function output(data) {
		  var json = JSON.parse(data);
          var element = document.getElementById("output");
		  element.innerHTML += json.messages;
        }
        var Socket = "MozWebSocket" in window ? MozWebSocket : WebSocket;
        var ws = new Socket("ws://localhost:4343");
		ws.onmessage = function(evt) { output(evt.data); }
        ws.onclose = function(event) {
          console.log("Closed WebSocket - code: " + event.code + ", reason: " + event.reason + ", wasClean: " + event.wasClean);
        };
        ws.onopen = function() {
          console.log("Opened WebSocket");
        };
		var controls = document.getElementById("controls");
		controls.addEventListener('submit', (evt) => {
			evt.preventDefault();
			var command = document.getElementById("command");
			ws.send(command.value);
			command.value = '';
		});
      };
    </script>
  </head>
  <body onload="init();">
    <div id="output"></div>
	<form id="controls">
		<input type="text" name="command" id="command" />
	</form>
  </body>
</html>
```

## Other Configuration Options

```ruby
# Change the host and port
Gamefic::Mud::Engine.start(plot) do |engine|
  engine.will_accept_tcpsocket host: 'example.com', port: 1000
  engine.will_accept_websocket host: 'example.com', port: 1001
end

# Change the tick interval (default is 1 second)
Gamefic::Mud::Engine.start(plot, interval: 3)
```
