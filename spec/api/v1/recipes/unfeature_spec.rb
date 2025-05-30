describe "recipes#unfeature", type: :request do
  subject(:make_request) do
    patch "/api/v1/recipes/#{recipe.id}/unfeature", params: {}, headers: { Authorization: token }
  end

  describe 'request' do
    let(:recipe) { create(:recipe, featured: true) }

    context 'success path' do
      let(:token) { recipe.author.user.token }

      it 'returns no_content status' do
        make_request
        expect(response).to have_http_status(:no_content)
      end

      it 'updates recipe properly' do
        expect(recipe.featured).to eq(true)
        make_request
        expect(recipe.reload.featured).to eq(false)
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
    end
  end
end
