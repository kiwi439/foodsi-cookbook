describe FeaturedRecipeValidator do
  describe '#validate' do
    subject { described_class.new.validate(recipe) }

    context 'when record is valid' do
      let(:recipe) { build(:recipe) }

      it "doesn't add validation errors when record is valid" do
        subject
        expect(recipe.errors.empty?).to eq(true)
      end
    end

    context 'when record is not valid' do
      context 'when exists three featured recipies' do
        let(:recipe) { build(:recipe, author: author, featured: true) }
        let(:author) { create(:author) }

        before do
          create_list(:recipe, FeaturedRecipeValidator::MAX_QUANTITY_OF_FEATURED_RECIPIES, author: author, featured: true)
        end

        it 'adds validation error to recipe' do
          subject
          expect(recipe.errors.to_a.count).to eq(1)
          expect(recipe.errors[:feature]).to eq(['to much featured recipes. Max quantity is: 3'])
        end
      end

      context "when recipe doesn't belong to top by likes" do
        let(:recipe) { build(:recipe, author: author, featured: true) }
        let(:author) { create(:author) }

        before do
          create_list(:recipe, 2, author: author, featured: true)
          create_list(:recipe, 28, author: author)
          Recipe.first(11).each do |recipe|
            recipe.likes << create_list(:like, 3, recipe: recipe)
          end
        end

        it 'adds validation error to recipe' do
          subject
          expect(recipe.errors.to_a.count).to eq(1)
          expect(recipe.errors[:feature]).to eq(['recipe has to belong to top 10 by likes'])
        end
      end
    end
  end
end
