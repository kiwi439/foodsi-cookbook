describe "recipes#feature", type: :request do
  subject(:make_request) do
    patch "/api/v1/recipes/#{recipe.id}/feature", params: {}, headers: { Authorization: token }
  end

  describe 'request' do
    let(:recipe) { create(:recipe) }

    context 'success path' do
      let(:token) { recipe.author.user.token }

      it 'returns no_content status' do
        make_request
        expect(response).to have_http_status(:no_content)
      end

      it 'updates recipe properly' do
        expect(recipe.featured).to eq(false)
        make_request
        expect(recipe.reload.featured).to eq(true)
      end
    end

    context 'error path' do
      context 'when user is not authenticated' do
        let(:token) { nil }

        before { make_request }

        it 'returns 401 status' do
          expect(response).to have_http_status(401)
        end
      end

      context 'when recipe belongs to different author' do
        let(:token) { create(:author).user.token }

        before { make_request }

        it 'returns 404 status' do
          expect(response).to have_http_status(404)
        end
      end

      context 'when model validation raises error' do
        let(:token) { recipe.author.user.token }

        before do
          create_list(:recipe, 3, author: recipe.author, featured: true)
          make_request
        end

        it 'returns unprocessable_entity status when validation fails' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns proper response' do
          json = JSON.parse(response.body)

          expect(json).to eq({ "errors" => ["Feature to much featured recipes. Max quantity is: 3"] })
        end
      end
    end
  end
end
