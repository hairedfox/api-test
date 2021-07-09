class DeleteComment < BaseService
  def initialize(comment_id, current_user)
    @comment_id = comment_id
    @current_user = current_user
    super()
  end

  def perform
    comment.destroy
    self
  rescue StandardError => e
    @errors[:base] = e.message

    self
  end

  private

  def comment
    @comment ||= current_user.comments.find(comment_id)
  end

  attr_reader :comment_id, :current_user
end
