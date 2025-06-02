describe Category, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:recipe_categories).dependent(:destroy) }
    it { is_expected.to have_many(:recipes).through(:recipe_categories) }
  end

  describe 'validations' do
    let(:category) { build(:category) }

    it 'raises validation error when name is not present' do
      category.name = nil

      expect(category.valid?).to eq(false)
      expect(category.errors[:name].size).to eq(2)
      expect(category.errors[:name]).to include("can't be blank")
      expect(category.errors[:name]).to include("is too short (minimum is 3 characters)")
    end

    it 'raises validation error when name is to short' do
      category.name = 'ab'

      expect(category.valid?).to eq(false)
      expect(category.errors[:name].size).to eq(1)
      expect(category.errors[:name]).to include("is too short (minimum is 3 characters)")
    end

    it 'raises validation error when name is to long' do
      category.name = 'a' * 101

      expect(category.valid?).to eq(false)
      expect(category.errors[:name].size).to eq(1)
      expect(category.errors[:name]).to include("is too long (maximum is 100 characters)")
    end

    it "doesn't raise validation error when each field is valid" do
      expect(category.valid?).to eq(true)
      expect(category.errors.empty?).to eq(true)
    end
  end

  describe 'enum' do
    it 'defines proper enum' do
      expect(Category.defined_enums["group"]).to eq({
        "diet" => :diet,
        "cuisine" => :cuisine,
        "dish_type" => :dish_type,
        "occasion" => :occasion
      })
    end
  end
end
