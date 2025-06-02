describe Like, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:recipe) }
    it { is_expected.to belong_to(:recipe) }
  end

  describe 'validations' do
    it "raises validation error when try to create more than one like related with the same user and recipe" do
      like = create(:like)
      like2 = build(:like, user: like.user, recipe: like.recipe)

      expect(like2.valid?).to eq(false)
      expect(like2.errors[:user_id].size).to eq(1)
      expect(like2.errors[:user_id]).to include("has already liked this recipe")
    end

    it 'properly creates like when belong to other user' do
      user = create(:user)
      like = create(:like)
      like2 = build(:like, user: user, recipe: like.recipe)

      expect(like2.valid?).to eq(true)
      expect(like2.errors.empty?).to eq(true)
    end
  end
end
