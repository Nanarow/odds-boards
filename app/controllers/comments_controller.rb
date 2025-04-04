class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ upvote downvote ]
  before_action :authenticate_user!, only: %i[ upvote downvote ]
  before_action :authorize_commenter, only: %i[ update destroy ]


  def upvote
    @comment.upvote current_user
    redirect_to boards_path
  end

  def downvote
    @comment.downvote current_user
    redirect_to boards_path
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_commenter
    unless current_user == @comment.commenter
      redirect_to boards_path, alert: "You can only modify your own comments."
    end
  end

  def comment_params
    params.expect(board: [ :commenter_id, :body, :parent_id ])
  end
end
