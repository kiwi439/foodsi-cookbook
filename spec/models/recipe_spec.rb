describe Recipe, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to have_many(:recipe_categories).dependent(:destroy) }
    it { is_expected.to have_many(:categories).through(:recipe_categories) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
  end

  describe 'validations' do
    let(:recipe) { build(:recipe) }

    it 'raises validation error when title is not present' do
      recipe.title = nil

      expect(recipe.valid?).to eq(false)
      expect(recipe.errors[:title].size).to eq(2)
      expect(recipe.errors[:title]).to include("can't be blank")
      expect(recipe.errors[:title]).to include("is too short (minimum is 3 characters)")
    end

    it 'raises validation error when title is to short' do
      recipe.title = 'ab'

      expect(recipe.valid?).to eq(false)
      expect(recipe.errors[:title].size).to eq(1)
      expect(recipe.errors[:title]).to include("is too short (minimum is 3 characters)")
    end

    it 'raises validation error when title is to long' do
      recipe.title = 'a' * 101

      expect(recipe.valid?).to eq(false)
      expect(recipe.errors[:title].size).to eq(1)
      expect(recipe.errors[:title]).to include("is too long (maximum is 100 characters)")
    end

    it 'raises validation error when text is not present' do
      recipe.text = nil

      expect(recipe.valid?).to eq(false)
      expect(recipe.errors[:text].size).to eq(2)
      expect(recipe.errors[:text]).to include("can't be blank")
      expect(recipe.errors[:text]).to include("is too short (minimum is 10 characters)")
    end

    it 'raises validation error when text is to short' do
      recipe.text = 'a' * 9

      expect(recipe.valid?).to eq(false)
      expect(recipe.errors[:text].size).to eq(1)
      expect(recipe.errors[:text]).to include("is too short (minimum is 10 characters)")
    end

    it 'raises validation error when text is to long' do
      recipe.text = 'a' * 1001

      expect(recipe.valid?).to eq(false)
      expect(recipe.errors[:text].size).to eq(1)
      expect(recipe.errors[:text]).to include("is too long (maximum is 1000 characters)")
    end

    it 'raises validation error when preparation_time is not present' do
      recipe.preparation_time = nil

      expect(recipe.valid?).to eq(false)
      expect(recipe.errors[:preparation_time].size).to eq(2)
      expect(recipe.errors[:preparation_time]).to include("can't be blank")
      expect(recipe.errors[:preparation_time]).to include("is not a number")
    end

    it 'raises validation error when preparation_time is not a number' do
      recipe.preparation_time = 'abc'

      expect(recipe.valid?).to eq(false)
      expect(recipe.errors[:preparation_time].size).to eq(1)
      expect(recipe.errors[:preparation_time]).to include("is not a number")
    end

    it 'raises validation error when preparation_time is not bigger than 0' do
      recipe.preparation_time = 0

      expect(recipe.valid?).to eq(false)
      expect(recipe.errors[:preparation_time].size).to eq(1)
      expect(recipe.errors[:preparation_time]).to include("must be greater than 0")
    end

    it "calls FeaturedRecipeValidator to validate 'featured' field" do
      create_list(:recipe, 3, author: recipe.author, featured: true)

      expect { create(:recipe, author: recipe.author, featured: true) }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Feature to much featured recipes. Max quantity is: 3')
    end
  end

  describe 'enum' do
    it 'defines proper enum' do
      expect(Recipe.difficulties).to eq({
        "easy" => 0,
        "medium" => 1,
        "hard" => 2,
        "expert" => 3
      })
    end
  end

  describe 'model methods' do
    let(:recipe) { create(:recipe) }
    let(:likes) { create_list(:like, 5, recipe: recipe) }

    it "returns quantity of recipie's likes" do
      likes

      expect(recipe.likes_count).to eq(5)
    end
  end
end
