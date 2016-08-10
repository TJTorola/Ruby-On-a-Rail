require 'rack'
require_relative '../lib/head'

app = Rail.new

app = Rack::Builder.new do
	use Static
	run app
end.to_app

app = Rack::Builder.new do
	use ShowExceptions
	run app
end.to_app

Rack::Server.start(
	app: app,
	Port: 3000
)