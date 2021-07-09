class CommentsController < ApplicationController
  def create
    service = CommentServices::Create.new(params[:post_id], current_user).perform

    return render_error(service) if service.has_error?

    render_with_serializer(service.result, :comment)
  end

  def update
    service = CommentServices::Update.new(params, current_user).perform

    return render_error(service) if service.has_error?

    render_with_serializer(service.result, :comment)
  end

  def destroy
    service = CommentServices::Delete.new(params[:id], current_user).perform

    return render_error(service) if service.has_error?

    render json: {}, status: :ok
  end
end
