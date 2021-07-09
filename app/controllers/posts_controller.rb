class PostsController < ApplicationController
  def show
    post = Post.find(params[:id])

    render json: PostSerializer.new(post).serializable_hash
  end

  def create
    service = CreatePost.new(post_params, current_user).perform

    return render json: { error: service.errors }, status: :bad_request if service.errors.present?

    render json: PostSerializer.new(service.result).serializable_hash
  end

  def update
    service = UpdatePost.new(post_params, current_user).perform

    return render json: { error: service.errors }, status: :bad_request if service.errors.present?

    render json: PostSerializer.new(service.result).serializable_hash
  end

  def destroy
    service = DeletePost.new(params[:id], current_user).perform

    return render json: { error: service.errors }, status: :bad_request if service.errors.present?

    render json: {}, status: :ok
  end

  private

  def post_params
    params.permit(:title, :body)
  end
end
