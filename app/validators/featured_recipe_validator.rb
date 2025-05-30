class FeaturedRecipeValidator < ActiveModel::Validator
  MAX_QUANTITY_OF_FEATURED_RECIPIES = 3
  REQUIRED_LIKES_POSITION_THRESHOLD = 10

  def validate(record)
    return unless record.will_save_change_to_featured?

    if has_exceded_featured_limit?(recipe: record)
      record.errors.add(:feature, "to much featured recipes. Max quantity is: #{MAX_QUANTITY_OF_FEATURED_RECIPIES}")
      return
    end

    unless belongs_to_top_author_recipes?(recipe: record)
      record.errors.add(:feature, "recipe has to belong to top #{REQUIRED_LIKES_POSITION_THRESHOLD} by likes")
      return
    end
  end

  private

  def has_exceded_featured_limit?(recipe:)
    recipe.author.recipes.where(featured: true).where.not(id: recipe.id).count >= MAX_QUANTITY_OF_FEATURED_RECIPIES
  end

  def belongs_to_top_author_recipes?(recipe:)
    top_ids = recipe.author.recipes
      .joins(:likes)
      .group('recipes.id')
      .order('COUNT(likes.id) DESC')
      .limit(REQUIRED_LIKES_POSITION_THRESHOLD)
      .pluck(:id)

    return true if top_ids.size < REQUIRED_LIKES_POSITION_THRESHOLD

    top_ids.include?(recipe.id)
  end
end
