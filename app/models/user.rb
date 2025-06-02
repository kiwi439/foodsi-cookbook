class User < ApplicationRecord
  before_validation :generate_token

  has_one :author, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :nickname, presence: true, length: { maximum: 100, minimum: 3 }
  validates :token, presence: true, length: { is: 32 }

  def generate_token
    self.token = SecureRandom.hex
  end
end
