class PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[create destroy]

  def create
    comment = current_user.post_comments.new(comment_params)
    comment.post_id = @post.id
    comment.save
    post_comments = @post.post_comments.includes(:user).order('created_at DESC')
    @comments_latest = post_comments.first(4)
    @comments_offset = post_comments.offset(4)
  end

  def destroy
    post_comment = PostComment.find_by(id: params[:id])
    post_comment.destroy if post_comment.user_id == current_user.id
    post_comments = @post.post_comments.includes(:user).order('created_at DESC')
    @comments_latest = post_comments.first(4)
    @comments_offset = post_comments.offset(4)
  end

  private

  def comment_params
    params.require(:post_comment).permit(:comment)
  end

  def set_comment
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.new
  end
end
