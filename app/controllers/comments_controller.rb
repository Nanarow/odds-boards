class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ upvote downvote edit update destroy confirm_delete cancel_edit ]
  before_action :set_parent, only: %i[ new_reply cancel_new_reply ]
  before_action :authenticate_user!, only: %i[ upvote downvote edit update destroy ]
  before_action :authorize_commenter, only: %i[ update destroy edit update destroy ]

  def upvote
    @comment.upvote current_user
  end

  def downvote
    @comment.downvote current_user
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.commenter = current_user
    if @comment.save
      @board = @comment.board
      render :create, status: :created
    else
      @parent_id = comment_params[:parent_id]
      render :new_reply, status: :unprocessable_entity
    end
  end

  def update
    if @comment.nil?
      return create
    end
    if @comment.update(comment_params)
      render :update, notice: "Comment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @board = @comment.board
    @comment.destroy!
    render :destroy, notice: "Comment was successfully destroyed."
  end

  def edit
  end

  def cancel_edit
  end

  def new_reply
  end

  def cancel_new_reply
  end

  def confirm_delete
  end

  def cancel_new
    @comment = Comment.new
    @board_id = params[:board_id]
    @parent_id = params[:parent_id]
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end
  def set_parent
    @parent = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id, :board_id)
  end

  def authorize_commenter
    unless @comment.nil? || current_user == @comment.commenter
      redirect_to boards_path, alert: "You can only modify your own comments."
    end
  end
end
