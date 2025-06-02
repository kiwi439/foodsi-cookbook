describe "likes#show", type: :request do
  subject(:make_request) do
    jsonapi_get "/api/v1/likes/#{like.id}", params: {}
  end

  describe 'request' do
    let(:like) { create(:like) }

    before(:each) do
      like
      make_request
    end

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a valid JSON:API response' do
      json = JSON.parse(response.body)

      expect(json).to include("data")
      expect(json["data"]).to be_a(Hash)
      expect(json["data"]).to include("id", "type", "attributes", "relationships")
      expect(json["data"]["type"]).to eq("likes")
    end
  end
end
