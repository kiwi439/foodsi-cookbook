describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_one(:author).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
  end

  describe 'callbacks' do
    before do
      allow(SecureRandom).to receive(:hex).and_return('53d0f0c9d776ee30c70c074859123fff')
    end

    it 'generates token before create' do
      user = create(:user)
      expect(user.token).to eq('53d0f0c9d776ee30c70c074859123fff')
    end
  end

  describe 'validations' do
    let(:user) { build(:user) }

    it 'raises validation error when nickname is not present' do
      user.nickname = nil

      expect(user.valid?).to eq(false)
      expect(user.errors[:nickname].size).to eq(2)
      expect(user.errors[:nickname]).to include("can't be blank")
      expect(user.errors[:nickname]).to include("is too short (minimum is 3 characters)")
    end

    it 'raises validation error when nickname is to short' do
      user.nickname = 'ab'

      expect(user.valid?).to eq(false)
      expect(user.errors[:nickname].size).to eq(1)
      expect(user.errors[:nickname]).to include("is too short (minimum is 3 characters)")
    end

    it 'raises validation error when nickname is to long' do
      user.nickname = 'a' * 101

      expect(user.valid?).to eq(false)
      expect(user.errors[:nickname].size).to eq(1)
      expect(user.errors[:nickname]).to include("is too long (maximum is 100 characters)")
    end

    it 'raises validation error when token is not present' do
      User.skip_callback(:validation, :before, :generate_token)
      user.token = nil

      expect(user.valid?).to eq(false)
      expect(user.errors[:token].size).to eq(2)
      expect(user.errors[:token]).to include("can't be blank")
      expect(user.errors[:token]).to include("is the wrong length (should be 32 characters)")

      User.set_callback(:validation, :before, :generate_token)
    end

    it 'raises validation error when token is the wrong length' do
      User.skip_callback(:validation, :before, :generate_token)
      user.token = 'cdd9a21c8345e693bc9cdbc1b8cfd'

      expect(user.valid?).to eq(false)
      expect(user.errors[:token].size).to eq(1)
      expect(user.errors[:token]).to include("is the wrong length (should be 32 characters)")

      User.set_callback(:validation, :before, :generate_token)
    end

    it "doesn't raise validation error when each field is valid" do
      expect(user.valid?).to eq(true)
      expect(user.errors.empty?).to eq(true)
    end
  end
end
