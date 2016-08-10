require 'rack'
require_relative '../lib/head'

app = Rack::Builder.new do
	use Exceptions
	use Static
	run Rail.new
end.to_app

Rack::Server.start(
	app: app,
	Port: 3000
)