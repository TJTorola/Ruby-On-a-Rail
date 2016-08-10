require 'mimemagic'

ACCEPTED_FORMATS = [
	'text/plain',
	'image/jpeg',
	'application/zip'
]

class Static
	def initialize(app)
		@app = app
		@root = :assets
	end

	def call(env)
		@req = Rack::Request.new(env)
		@res = Rack::Response.new

		if asset?
			return ['200', {'Content-type' => mime}, File.open(path)]
		else
			@app.call(env)
		end
	end

	private

	def dir
		File.dirname(__FILE__)
	end

	def path
		"#{dir}/../../#{@root}#{@req.path}"
	end

	def exists?
		File.exist?(path)
	end

	def accepted?
		return false unless mime
		ACCEPTED_FORMATS.include? mime
	end

	def mime
		mm = MimeMagic.by_path(path)
		return unless mm
		@mime ||= MimeMagic.by_path(path).type
	end

	def asset?
		exists? && accepted?
	end
end
