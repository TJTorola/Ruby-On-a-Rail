require 'rack'
require_relative '../lib/rail'

class ApplicationController < ControllerBase
  protect_from_forgery

  def show
    render_content("RAIL!", "text/html")
  end

  def show_cats
    render_content(@params[:cat_id], "text")
  end
end

router = Router.new
router.draw do
  get "/", 'ApplicationController#show'
  get "/cats/:cat_id/toy/:id", "ApplicationController#showCats"
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

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
