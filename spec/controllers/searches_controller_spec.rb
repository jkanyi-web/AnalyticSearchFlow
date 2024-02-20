require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  let(:valid_session_id) { 'valid_session_id' }
  let!(:valid_search) { Search.create!(query: 'test', session_id: valid_session_id) }
  let(:valid_search_event_params) { { search_id: valid_search.id, event_type: 'start', session_id: valid_session_id } }
  let(:invalid_search_event_params) { { search_id: valid_search.id, event_type: '', session_id: '' } }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new SearchEvent' do
        expect {
          post :create, params: { search_event: valid_search_event_params }
        }.to change(SearchEvent, :count).by(1)
        puts response.body
      end

      it 'renders a JSON response with the new search event' do
        post :create, params: { search_event: valid_search_event_params }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new search event' do
        post :create, params: { search_event: invalid_search_event_params }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'POST #finalize_search' do
    context 'with valid params' do
      it 'creates a new Search' do
        post :finalize_search, params: { search: valid_search.attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new search' do
        post :finalize_search, params: { search: { query: '', session_id: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end
