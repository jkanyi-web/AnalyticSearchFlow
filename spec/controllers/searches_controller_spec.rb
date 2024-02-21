require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  let(:valid_session_id) { 'valid_session_id' }
  let(:valid_search_params) { { query: 'test', session_id: valid_session_id } }
  let(:invalid_search_params) { { query: '', session_id: '' } }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Search' do
        expect {
          post :create, params: { search: valid_search_params }
        }.to change(Search, :count).by(1)
      end

      it 'creates a new Search with the correct attributes' do
        post :create, params: { search: valid_search_params }
        search = Search.last
        expect(search.query).to eq('test')
        expect(search.session_id).to eq(valid_session_id)
      end

      it 'renders a JSON response with the new search' do
        post :create, params: { search: valid_search_params }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to include('Search was successfully logged.')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new search' do
        post :create, params: { search: invalid_search_params }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to include('errors')
      end
    end
  end
end
