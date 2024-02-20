class SearchesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @searches = Search.includes(:search_events).all
  end

  def create
    @search = Search.create(search_params)

    if @search.persisted?
      render json: { message: 'Search was successfully logged.' }, status: :created
    else
      render json: { errors: @search.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def finalize_search
    @search = Search.find_by(session_id: search_params[:session_id])

    if @search
      @search.update(search_params)
    else
      @search = Search.create(search_params)
    end

    SearchEvent.where(session_id: @search.session_id).update_all(search_id: @search.id)

    if @search.persisted?
      render json: { message: 'Search was successfully logged.' }, status: :created
    else
      render json: { errors: @search.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def search_event_params
    params.require(:search_event).permit(:search_id, :event_type, :session_id)
  end

  def search_params
    params.require(:search).permit(:query, :session_id)
  end
end
