class SearchesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @searches = Search.all
  end

  def create
    @search = Search.create(search_params.merge(ip_address: request.remote_ip))

    if @search.persisted?
      Rails.cache.delete('most_common_queries')
      render json: { message: 'Search was successfully logged.' }, status: :created
    else
      render json: { errors: @search.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def analytics
    most_common_queries = Rails.cache.fetch('most_common_queries', expires_in: 12.hours) do
      Search.group(:query).order('count_id DESC').limit(10).count(:id)
    end
    render json: most_common_queries
  end

  private

  def search_params
    params.require(:search).permit(:query, :session_id)
  end
end
