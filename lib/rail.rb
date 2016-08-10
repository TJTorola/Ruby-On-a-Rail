class Rail
	def call(env)
		req = Rack::Request.new(env)
		res = Rack::Response.new

		@@router.run(req, res)
		res.finish
	end

	def self.router
		@@router ||= Router.new
	end
end