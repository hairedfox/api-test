class CommentsController < ApplicationController
  def create
    service = CreateComment.new(params[:post_id], current_user).perform

    return render json: { error: service.errors }, status: :bad_request if service.errors.present?

    render json: CommentSerializer.new(service.result).serializable_hash, status: :ok
  end

  def update
    service = UpdateComment.new(params, current_user).perform

    return render json: { error: service.errors }, status: :bad_request if service.errors.present?

    render json: CommentSerializer.new(service.result).serializable_hash, status: :ok
  end

  def destroy
    service = DeleteComment.new(params[:id], current_user).perform

    return render json: { error: service.errors }, status: :bad_request if service.errors.present?

    render json: {}, status: :ok
  end
end
