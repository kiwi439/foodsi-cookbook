describe Authors::StatisticsService, type: :service do
  describe '#call' do
    subject { described_class.new(author_id: author.id, group_by: group_by).call }

    context 'success path' do
      context "when group_by is 'category'" do
        let(:author) { create(:author) }
        let(:group_by) { 'category' }

        before do
          author

          recipe1 = create(:recipe, author: author)
          recipe2 = create(:recipe, author: author)
          recipe3 = create(:recipe, author: author)

          category1 = create(:category, name: 'Breakfast')
          category2 = create(:category, name: 'Italian')
          category3 = create(:category, name: 'Chinese')

          recipe1.categories << category1
          recipe1.categories << category2
          recipe2.categories << category1
          recipe3.categories << category3

          create_list(:like, 13, recipe: recipe1)
          create_list(:like, 4, recipe: recipe2)
          create(:like, recipe: recipe3)

          # Ignore recipies related with different autor
          other_author = create(:author)
          recipe4 = create(:recipe, author: other_author)
          recipe4.categories << category1
          create_list(:like, 50, recipe: recipe4)
        end

        it 'returns proper response' do
          expect(subject.to_json).to eq([
            {
              id: author.id,
              group_value: 'Breakfast',
              grouped_by: group_by,
              recipes_quantity: 2,
              likes_quantity: 17
            },
            {
              id: author.id,
              group_value: 'Chinese',
              grouped_by: group_by,
              recipes_quantity: 1,
              likes_quantity: 1
            },
            {
              id: author.id,
              group_value: 'Italian',
              grouped_by: group_by,
              recipes_quantity: 1,
              likes_quantity: 13
            }
          ].to_json)
        end
      end

      context "when group_by is 'week'" do
        let(:author) { create(:author) }
        let(:group_by) { 'week' }

        before do
          Timecop.freeze(Date.new(2025, 6, 15))

          author

          recipe1 = create(:recipe, author: author)
          recipe2 = create(:recipe, author: author)
          recipe3 = create(:recipe, author: author, created_at: Date.new(2025, 8, 15))

          create_list(:like, 13, recipe: recipe1)
          create_list(:like, 4, recipe: recipe2)
          create(:like, recipe: recipe3)

          # Ignore recipies related with different autor
          other_author = create(:author)
          recipe4 = create(:recipe, author: other_author)
          create_list(:like, 50, recipe: recipe4)
        end

        after  { Timecop.return }

        it 'returns proper response' do
          expect(subject.to_json).to eq([
            {
              id: author.id,
              group_value: '09.06.2025 - 15.06.2025',
              grouped_by: group_by,
              recipes_quantity: 2,
              likes_quantity: 17
            },
            {
              id: author.id,
              group_value: '11.08.2025 - 17.08.2025',
              grouped_by: group_by,
              recipes_quantity: 1,
              likes_quantity: 1
            }
          ].to_json)
        end
      end

      context "when group_by is 'month'" do
        let(:author) { create(:author) }
        let(:group_by) { 'month' }

        before do
          Timecop.freeze(Date.new(2025, 6, 15))

          author

          recipe1 = create(:recipe, author: author)
          recipe2 = create(:recipe, author: author)
          recipe3 = create(:recipe, author: author, created_at: Date.new(2025, 8, 15))

          create_list(:like, 13, recipe: recipe1)
          create_list(:like, 4, recipe: recipe2)
          create(:like, recipe: recipe3)

          # Ignore recipies related with different autor
          other_author = create(:author)
          recipe4 = create(:recipe, author: other_author)
          create_list(:like, 50, recipe: recipe4)
        end

        after  { Timecop.return }

        it 'returns proper response' do
          expect(subject.to_json).to eq([
            {
              id: author.id,
              group_value: '01.06.2025 - 30.06.2025',
              grouped_by: group_by,
              recipes_quantity: 2,
              likes_quantity: 17
            },
            {
              id: author.id,
              group_value: '01.08.2025 - 31.08.2025',
              grouped_by: group_by,
              recipes_quantity: 1,
              likes_quantity: 1
            }
          ].to_json)
        end
      end
    end

    context 'error path' do
      let(:author) { create(:author) }
      let(:group_by) { 'day' }

      it 'raises ParamsError for invalid group_by' do
        expect { subject }.to raise_error(Authors::StatisticsService::ParamsError, "group_by can't be 'day', permitted values: category, week, month")
      end
    end
  end
end
