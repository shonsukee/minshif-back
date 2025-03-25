class StaticPageController < ApplicationController
	def index
		render json: { message: "hello from minshif server!" }
	end
end
