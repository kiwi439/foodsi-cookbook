class UsersController < ApplicationController
  def show
    user = UserResource.find(params)
    respond_with(user)
  end
end
