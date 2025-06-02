class AddFeaturedToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :featured, :boolean, default: false

    Recipe.find_each(batch_size: 500) do |recipe|
      recipe.update!(featured: false)
    end

    change_column_null :recipes, :featured, false
  end
end
