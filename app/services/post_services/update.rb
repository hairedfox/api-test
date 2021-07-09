class PostServices::Update < BaseService
  def initialize(params, current_user)
    @params = params
    @current_user = current_user
    super()
  end

  def perform
    update_post!

    self
  rescue StandardError => e
    set_up_error(e)
  end

  private

  def update_post!
    post.update!(
      title: params[:title],
      body: params[:body]
    )
  end

  def post
    @post ||= current_user.posts.find_by!(id: params[:id])
  end

  attr_reader :params, :current_user
end
