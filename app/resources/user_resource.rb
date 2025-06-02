class UserResource < ApplicationResource
  attribute :id, :integer, readable: true
  attribute :nickname, :string
  attribute :token, :string
  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  has_one :author
  has_many :likes
end
