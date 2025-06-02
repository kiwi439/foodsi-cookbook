class LikesController < ApplicationController
  def index
    likes = LikeResource.all(params)
    respond_with(likes)
  end

  def show
    like = LikeResource.find(params)
    respond_with(like)
  end

  def create
    return authenticate_user! unless current_user

    like = LikeResource.build(create_params)

    if like.save
      render jsonapi: like, status: 201
    else
      render jsonapi_errors: like
    end
  end

  def destroy
    return authenticate_user! unless current_user

    like = LikeResource.find(destroy_params)

    if like.destroy
      render jsonapi: { meta: {} }, status: 200
    else
      render jsonapi_errors: like
    end
  end

  private

  def create_params
    params['data']['attributes']['user_id'] = current_user.id
    params
  end

  def destroy_params
    params['filter'] = { id: params[:id], user_id: current_user.id }
    params
  end
end
