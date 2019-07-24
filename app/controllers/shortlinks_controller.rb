class ShortlinksController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? || request.format.xml? }
  before_action :find_short_link, only: [:redirect, :stats]

  # Executes redirect for short link.
  def redirect
    @short_link.update_stats

    redirect_to @short_link.original_url
  end

  # Returns a JSON object containing stats on a given shortlink.
  def stats
    render json: {
      created_at: @short_link.created_at,
      total_visits: @short_link.total_hits,
      hit_counts: @short_link.hit_by_day_hash
    }
  end

  # Creates a new shortlink from a full URL.
  def new
    s = ShortLink.create_from_url(params[:link])

    render json: { hash: s.short_url }
  end

  private

  # Creates a new shortlink from a full URL.
  def find_short_link
    @short_link = ShortLink.find_by_short_url(params[:hash])

    if @short_link.nil?
      respond_to do |format|
        format.html { render file: File.join(Rails.root, 'public', '404.html') }
        format.json { render json: { error: 'not_found' }, status: :not_found }
      end
    end

    @short_link
  end
end
