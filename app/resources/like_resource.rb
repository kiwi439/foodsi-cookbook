class LikeResource < ApplicationResource
  attribute :user_id, :integer
  attribute :recipe_id, :integer

  belongs_to :user
  belongs_to :recipe
end
