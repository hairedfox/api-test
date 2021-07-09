class CommentServices::Update < BaseService
  def initialize(params, current_user)
    @params = params
    @current_user = current_user
    super()
  end

  def perform
    update_comment!
    @result = comment

    self
  rescue StandardError => e
    set_up_error(e)
  end

  private

  def update_comment!
    comment.update!(content: params[:content])
  end

  def comment
    @comment ||= current_user.comments.find(params[:id])
  end

  attr_reader :params, :current_user
end
