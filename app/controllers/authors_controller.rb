class AuthorsController < ApplicationController
  def index
    authors = AuthorResource.all(params)
    respond_with(authors)
  end

  def show
    author = AuthorResource.find(params)
    respond_with(author)
  end

  def statistics
    group_by = params[:group_by] || 'category'
    author_id = params[:id]
    statistics = ::Authors::StatisticsService.new(author_id: author_id, group_by: group_by).call
    response = AuthorStatisticsSerializer.new(statistics).serializable_hash

    render json: response, status: :ok
  rescue ::Authors::StatisticsService::ParamsError => e
    render json: { errors: [{ message: e.message }] }, status: :bad_request
  end
end
