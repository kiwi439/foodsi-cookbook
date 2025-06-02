describe "likes#destroy", type: :request do
  subject(:make_request) do
    delete "/api/v1/likes/#{like_id}", params: {}
  end

  describe 'request' do
    context 'success path' do
      let!(:like_id) { create(:like).id }

      it 'returns proper status' do
        make_request

        expect(response).to have_http_status(:ok)
      end

      it 'deletes like' do
        expect { make_request }.to change { Like.count }.from(1).to(0)
      end

      it 'returns a valid JSON:API response' do
        make_request

        json = JSON.parse(response.body)
        expect(json).to eq({ "meta" => {} })
      end
    end

    context 'erorr path' do
      let(:like_id) { 10 }

      it 'returns proper status' do
        make_request

        expect(response).to have_http_status(404)
      end

      it "doesn't delete like" do
        expect { make_request }.not_to change { Like.count }
      end

      it 'returns a valid JSON:API response' do
        make_request

        json = JSON.parse(response.body)

        expect(json).to eq(
          {
            "errors" => [
              {
                "code" => "not_found",
                "detail" => "Specified Record Not Found",
                "status" => "404",
                "title" => "Not Found"
              }
            ]
          }
        )
      end
    end
  end
end
