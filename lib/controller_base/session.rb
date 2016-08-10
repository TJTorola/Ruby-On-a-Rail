require 'json'

class Session
	def initialize(req)
		if req.cookies['_rail_app']
			@session = JSON.parse(req.cookies['_rail_app'])
		else
			@session = {}
		end
	end

	def [](key)
		@session[key]
	end

	def []=(key, value)
		@session[key] = value
	end

	def store_session(res)
		res.set_cookie('_rail_app', @session.to_json)
	end
end
