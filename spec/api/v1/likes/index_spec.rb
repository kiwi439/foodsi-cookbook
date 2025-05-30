describe "likes#index", type: :request do
  subject(:make_request) do
    jsonapi_get "/api/v1/likes", params: {}
  end

  describe 'request' do
    before(:each) do
      create_list(:like, 5)
      make_request
    end

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a valid JSON:API response' do
      json = JSON.parse(response.body)

      expect(json).to include("data")
      expect(json["data"]).to be_a(Array)
      expect(json["data"].length).to eq(5)

      json["data"].each do |object|
        expect(object).to include("id", "type", "attributes", "relationships")
        expect(object["type"]).to eq("likes")
      end
    end
  end
end
