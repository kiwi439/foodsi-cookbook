describe "authors#statistics", type: :request do
  subject(:make_request) do
    jsonapi_get "/api/v1/authors/#{author.id}/statistics", params: params
  end

  describe 'request' do
    context 'success path' do
      let(:params) { { group_by: 'month' } }
      let(:author) { create(:author) }

      before do
        Timecop.freeze(Date.new(2025, 6, 15))

        author
        recipe1 = create(:recipe, author: author)
        recipe2 = create(:recipe, author: author)
        create(:recipe, author: author)
        create(:like, user: author.user, recipe: recipe1)
        create(:like, user: author.user, recipe: recipe2)

        make_request
      end

      after  { Timecop.return }

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a valid JSON:API response' do
        json = JSON.parse(response.body)

        expect(json).to eq({
          "data" => [
            {
              "id" => author.id.to_s,
              "type" => 'author_statistics',
              "attributes" => {
                "grouped_by" => 'month',
                "group_value" => '01.06.2025 - 30.06.2025',
                "recipes_quantity" => 3,
                "likes_quantity" => 2
              }
            }
          ]
        })
      end
    end

    context 'error path' do
      let(:params) { { group_by: 'day' } }
      let(:author) { create(:author) }

      before do
        author
        make_request
      end

      it 'returns bad_request status' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
