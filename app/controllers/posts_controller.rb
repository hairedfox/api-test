class PostsController < ApplicationController
  def create
    service = CreatePost.new(post_params, current_user).perform

    return render json: { error: service.errors }, status: :bad_request if service.errors.present?

    render json: PostSerializer.new(service.result).serializable_hash
  end

  private

  def post_params
    params.permit(:title, :body)
  end
end
