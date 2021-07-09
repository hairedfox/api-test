class PostsController < ApplicationController
  def index
    filtered_posts = Post.ransack(params[:q]).result.order(created: :desc).includes(:comments, :user)

    @pagy, posts = pagy(filtered_posts, items: 20, page: params[:page])

    render json: {
      items: PostSerializer.new(posts).serializable_hash,
      pagy: @pagy
    }, status: :ok
  end

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

  def search_params
    params.require(:q).permit(
      :title_cont,
      :body_cont,
      :user_id_eq
    )
  end
end
