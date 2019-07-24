class ShortlinksController < ApplicationController
	protect_from_forgery unless: -> { request.format.json? || request.format.xml? }
	before_action :find_short_link, only: [:redirect, :stats]

	def redirect
		@short_link.total_visits = @short_link.total_visits + 1
		@short_link.save

		redirect_to @short_link.original_url
	end

	def stats
		render json: { 
			created_at: @short_link.created_at,
			total_visits: @short_link.total_visits
		}
	end 

	def new
		s = ShortLink.create_from_url(params[:link])

		render json: { hash: s.short_url }
	end

	private

	def	find_short_link
		@short_link = ShortLink.find_by_short_url(params[:hash])

		if @short_link.nil?
			render :file => "#{Rails.root}/public/404.html"
			return
		end

		@short_link
	end
end
