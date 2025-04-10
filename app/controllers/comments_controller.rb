class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ upvote downvote edit update destroy ]
  before_action :authenticate_user!, only: %i[ upvote downvote edit update destroy ]
  before_action :authorize_commenter, only: %i[ update destroy edit update destroy ]
  before_action :set_board, only: %i[ list create update destroy edit remove ]

  def list
    @comments = @board.comments_by_depth(0)
  end
  def remove
  end


  def upvote
    @comment.upvote current_user
  end

  def downvote
    @comment.downvote current_user
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.board = @board
    @comment.commenter = current_user
    if @comment.save
      render :create, status: :created
    else
      render :new, status: :unprocessable_entity
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
    @comment.destroy!
    render :destroy, notice: "Comment was successfully destroyed."
  end

  def edit
  end

  private

  def set_comment
    @comment = Comment.find_by(id: params[:id])
  end

  def set_board
    @board = Board.find(params[:board_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_commenter
    unless @comment.nil? || current_user == @comment.commenter
      redirect_to boards_path, alert: "You can only modify your own comments."
    end
  end
end
