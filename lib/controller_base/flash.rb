require 'json'

class Flash
	attr_accessor :now

	def initialize(req)
		cookie = req.cookies['_rail_app_flash']

		@past = cookie ? JSON.parse(cookie) : {}
		@future = {}
		@now = {}
	end

	def [](key)
		store[key]
	end

	def []=(key, value)
		@future[key] = value
	end

	def store
		@past.merge(@now).merge(@future)
	end

	def store_flash(res)
		res.set_cookie('_rail_app_flash', @future.to_json)
	end
end
