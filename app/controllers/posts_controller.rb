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

    render_with_serializer(post, :post)
  end

  def create
    service = PostServices::Create.new(post_params, current_user).perform

    return render_error(service) if service.has_error?

    render_with_serializer(service.result, :post)
  end

  def update
    service = PostServices::Update.new(params, current_user).perform

    return render_error(service) if service.has_error?

    render_with_serializer(service.result, :post)
  end

  def destroy
    service = PostServices::Delete.new(params[:id], current_user).perform

    return render_error(service) if service.has_error?

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
