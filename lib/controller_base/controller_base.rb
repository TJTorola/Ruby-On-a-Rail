PROTECTED_METHODS = ["PUT", "PATCH", "POST", "DELETE"]

require 'active_support'
require 'active_support/core_ext'
require 'erb'

require_relative './session'
require_relative './flash'

class ControllerBase
	attr_reader :req, :res, :params

	def initialize(req, res, route_params = {})
		@req, @res = req, res
		@built = false
		@params = route_params.merge(req.params)

		check_csrf
	end

	def redirect_to(url)
		build!

		@res.redirect(url)
	end

	def render(template_name)
		build!

		file = "#{template_dir}/#{template_name}.html.erb"
		render_content(build_template(file), 'text/html')
	end

	def invoke_action(name)
		self.send(name)
	end

	private

	def template_dir
		"./views/#{self.class.to_s.underscore}"
	end

	def build!
		raise 'Double Render' if built?
		@built = true
		store_session
	end

	def built?
		@built
	end

	def render_content(content, content_type)
		@res['Content-Type'] = content_type
		@res.write(content)
	end

	def build_template(path)
		file = File.read(path)
		erb = ERB.new(file)
		erb.result(binding)
	end

	def session
		@session ||= Session.new(@req)
	end

	def flash
		@flash ||= Flash.new(@req)
	end

	def store_session
		session.store_session(@res)
		flash.store_flash(@res)
	end

	def auth_input
		"<input type='hidden' name='authenticity_token' value='#{form_authenticity_token}'>"
	end

	def form_authenticity_token
		token = SecureRandom.urlsafe_base64(32)
		session['authenticity_token'] = token
		store_session
		token
	end

	def check_csrf
		return unless @@csrf_protected

		method = @req.request_method.upcase
		return unless PROTECTED_METHODS.include? method

		given_token = @params['authenticity_token']
		existing_token = session['authenticity_token']
		unless given_token && given_token == existing_token
			raise 'Invalid Authenticity Token' 
		end
	end

	protected

	def self.protect_from_forgery
		@@csrf_protected = true
	end
end

