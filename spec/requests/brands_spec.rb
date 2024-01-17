require 'rails_helper'

describe 'Brands Api', type: :request do
  describe 'GET /brands' do
    it 'returns all brands' do
      FactoryBot.create(:brand, name:'Ford', description: 'Ford desc')
      FactoryBot.create(:brand, name:'Tesla', description: 'Tesla desc')
      get '/api/v1/brands'

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'POST /brands do' do
    it 'create a new brand' do
      post '/api/v1/brands', params: { brand: {name: 'Ford', description: 'Ford desc'} }

      expect(response).to have_http_status(:unauthorized)
    end
  end

end
