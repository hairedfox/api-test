class CommentsController < ApplicationController
  def create
    service = CreateComment.new(params[:post_id], current_user).perform

    return render json: { error: service.errors }, status: :bad_request if service.errors.present?

    render json: CommentSerializer.new(service.result).serializable_hash, status: :ok
  end
end
