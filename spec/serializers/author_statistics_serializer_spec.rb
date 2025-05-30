describe AuthorStatisticsSerializer, type: :serializer do
  let(:statistics) do
    [
      OpenStruct.new(
        id: 1,
        grouped_by: 'week',
        group_value: '01.06.2025 – 07.06.2025',
        recipes_quantity: 5,
        likes_quantity: 3
      )
    ]
  end

  subject { described_class.new(statistics).serializable_hash.to_json }

  it 'returns correct serialized attributes' do
    expect(subject).to eq({
      "data" => [
        {
          "id" => '1',
          "type" => 'author_statistics',
          "attributes" => {
            "grouped_by" => 'week',
            "group_value" => '01.06.2025 – 07.06.2025',
            "recipes_quantity" => 5,
            "likes_quantity" => 3
          }
        }
      ]
    }.to_json)
  end
end
