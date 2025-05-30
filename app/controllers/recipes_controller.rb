class RecipesController < ApplicationController
  def index
    recipes = RecipeResource.all(params)
    respond_with(recipes)
  end

  def show
    recipe = RecipeResource.find(params)
    respond_with(recipe)
  end

  def feature
    return authenticate_user! unless current_user

    author = current_user.author
    recipe = author.recipes.find_by!(id: params[:id])
    recipe.update!(featured: true)

    head :no_content
  end

  def unfeature
    return authenticate_user! unless current_user

    author = current_user.author
    recipe = author.recipes.find_by!(id: params[:id])
    recipe.update!(featured: false)

    head :no_content
  end
end
