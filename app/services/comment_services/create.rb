class CommentServices::Create < BaseService
  def initialize(params, current_user)
    @params = params
    @current_user = current_user
    super()
  end

  def perform
    create_comment!

    self
  rescue StandardError => e
    set_up_error(e)
  end

  private

  def create_comment!
    Comment.create!(
      content: params[:content],
      post_id: params[:post_id],
      user: current_user
    )
  end

  attr_reader :params, :current_user
end
