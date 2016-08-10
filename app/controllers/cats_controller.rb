class CatsController < ApplicationController
	def index
		render_content(Cat.all.to_json, "text/json")
	end

	def show
		@cat = Cat.find(params[:id])
		render_content(@cat.to_json, "text/json")
	end
end