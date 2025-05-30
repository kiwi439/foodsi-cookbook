describe Author, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:recipes).dependent(:destroy) }
  end
end
