class PostServices::Create < BaseService
  def initialize(params, current_user)
    @params = params
    @current_user = current_user
    super()
  end

  def perform
    create_post!

    self
  rescue StandardError => e
    set_up_error(e)
  end

  private

  def create_post!
    @result = current_user.posts.create!(
      title: params[:title],
      body: params[:body]
    )
  end

  attr_reader :params, :current_user
end
