require 'erb'

class Exceptions
	attr_reader :app
	def initialize(app)
		@app = app
	end

	def call(env)
		@req = Rack::Request.new(env)
		@res = Rack::Response.new

		begin
			@app.call(env)
		rescue Exception => e
			@e = e
			return render_exception(e)
		end
	end

	private

	def render_exception(e)
		['500', {'Content-type' => 'text/html'}, [return_template]]
	end

	def return_template
		file = File.read(template_path)
		ERB.new(file).result(binding)
	end

	def template_path
		"#{dir}/../templates/exception.html.erb"
	end

	def dir
		File.dirname(__FILE__)
	end
end