require_relative './route.rb'

METHODS = [:get, :post, :put, :delete]

class Router
	attr_reader :routes

	def initialize
		@routes = []
	end

	def draw(&proc)
		self.instance_eval &proc
	end

	def run(req, res)
		route = match(req)

		if route
			route.run(req, res)
		else
			res.status = 404
			res['Content-Type'] = 'text/html'
			res.write(File.read("#{template_dir}404.html"))
			res.finish
		end
	end

	METHODS.each do |method|
		define_method(method) do |pattern, controller, action|
			add_route(pattern, method, controller, action)
		end
	end

	private

	def template_dir
		"#{dir}/../templates/"
	end

	def dir
		File.dirname(__FILE__)
	end

	def add_route(pattern, method, controller, action)
		@routes << Route.new(pattern, method, controller, action)
	end

	def match(req)
		@routes.find { |route| route.matches?(req) }
	end
end
