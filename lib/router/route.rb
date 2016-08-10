class Route
	attr_reader :pattern, :method, :controller, :action

	def initialize(pattern, method, controller, action)
		@pattern    = pattern
		@method     = method
		@controller = controller
		@action     = action
	end

	def matches?(req)
		return false unless @pattern.match(req.path)
		return false unless @method.to_s.upcase == req.request_method.upcase
		true
	end

	def run(req, res)
		instance = @controller.new(req, res, match_params(req))
		instance.invoke_action(action)
	end

	def match_params(req)
		match_data = @pattern.match(req.path)
		Hash[ match_data.names.zip( match_data.captures ) ]
	end
end