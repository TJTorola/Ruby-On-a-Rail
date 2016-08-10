require 'rack'
require_relative '../lib/head'

class ApplicationController < ControllerBase
  protect_from_forgery

  def show
    render_content("RAIL!", "text/html")
  end

  def show_cats
    render_content(@params[:cat_id], "text")
  end
end

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
