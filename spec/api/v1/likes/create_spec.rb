describe "likes#create", type: :request do
  subject(:make_request) do
    post "/api/v1/likes", params: { data: { type: "likes", attributes: { user_id: user.id, recipe_id: recipe.id } } }
  end

  describe 'request' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe) }

    context 'success path' do
      it 'returns proper status' do
        make_request

        expect(response).to have_http_status(:created)
      end

      it 'creates like' do
        expect { make_request }.to change { Like.count }.from(0).to(1)
      end

      it 'returns a valid JSON:API response' do
        make_request

        json = JSON.parse(response.body)
        expect(json).to include("data")
        expect(json["data"]).to be_a(Hash)
        expect(json["data"]).to include("id", "type", "attributes", "relationships")
        expect(json["data"]["type"]).to eq("likes")
      end
    end

    context 'erorr path' do
      before { create(:like, user: user, recipe: recipe) }

      it 'returns proper status' do
        make_request

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "doesn't create like" do
        expect { make_request }.not_to change { Like.count }
      end

      it 'returns a valid JSON:API response' do
        make_request

        json = JSON.parse(response.body)

        expect(json).to include("errors")
        expect(json["errors"]).to be_a(Array)
        expect(json["errors"].length).to eq(1)
        expect(json["errors"][0]["code"]).to eq('unprocessable_entity')
        expect(json["errors"][0]["status"]).to eq('422')
        expect(json["errors"][0]["title"]).to eq('Validation Error')
        expect(json["errors"][0]["detail"]).to eq('User has already liked this recipe')
      end
    end
  end
end
