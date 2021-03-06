class PostServices::Delete < BaseService
  def initialize(id, current_user)
    @id = id
    @current_user = current_user
    super()
  end

  def perform
    post.destroy

    self
  rescue StandardError => e
    set_up_error(e)
  end

  private

  def post
    @post ||= current_user.posts.find(id)
  end

  attr_reader :id, :current_user
end
