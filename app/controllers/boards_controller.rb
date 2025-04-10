class BoardsController < ApplicationController
  before_action :set_board, only: %i[ edit update destroy upvote downvote publish draft make_public make_private ]
  before_action :authenticate_user!, only: %i[ upvote downvote publish draft make_public make_private my_boards ]
  before_action :authorize_author, only: %i[ publish draft make_public make_private ]
  before_action :set_form, only: %i[ new edit ]
  # before_action :ensure_turbo_frame, only: [ :new ]

  def index
    condition = { state: :is_published }
    unless user_signed_in?
      condition[:visibility] = :is_public
    end
    set_boards(condition)
    set_categories
    set_tags
  end

  def my_boards
    set_boards author: current_user
    set_categories
    set_tags
    render :index
  end

  def new
    @board = Board.new
  end

  def edit
  end

  def create
    board = board_params
    tags = board.delete :tags
    @board = Board.new(board)
    @board.author = current_user

    if @board.save
      @board.set_tags(tags, current_user) unless tags.nil?
      set_categories
      set_tags
      render :create, status: :created
    else
      set_form
      render :new, status: :unprocessable_entity
    end
  end

  def update
    board = board_params
    tags = board.delete :tags
    if @board.update(board)
      @board.set_tags(tags, current_user) unless tags.nil? 
      set_categories
      set_tags
      render :update, notice: "Board was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @board.destroy!
    set_categories
    set_tags
    render :destroy, notice: "Board was successfully destroyed."
  end

  def upvote
    @board.upvote current_user
  end

  def downvote
    @board.downvote current_user
  end

  def publish
    if @board.can_publish? && @board.publish!
      redirect_to boards_path, notice: "Board published!"
    else
      redirect_to boards_path, alert: "Cannot publish this board."
    end
  end

  def draft
    if @board.can_draft? && @board.draft!
      redirect_to boards_path, notice: "Board reverted to draft!"
    else
      redirect_to boards_path, alert: "Cannot revert this board to draft."
    end
  end

  def make_public
    if @board.can_make_public? && @board.make_public!
      redirect_to boards_path, notice: "Board made public!"
    else
      redirect_to boards_path, alert: "Cannot make this board public."
    end
  end

  def make_private
    if @board.can_make_private? && @board.make_private!
      redirect_to boards_path, notice: "Board made private!"
    else
      redirect_to boards_path, alert: "Cannot make this board private."
    end
  end

  private
    def set_board
      @board = Board.find(params.expect(:id))
    end

    def set_boards(condition)
      @boards = Board.where(condition).order(created_at: :desc)
    end

    def set_categories
      @categories = Category
      .joins(:boards)
      .where(board_conditions)
      .distinct
      .order(name: :asc)
    end

    def set_tags
      @tags = Tag
      .joins(:boards)
      .where(board_conditions)
      .distinct
      .order(name: :asc)
    end

    def board_conditions
      if user_signed_in?
        Board.arel_table[:author_id].eq(current_user.id)
        .or(Board.arel_table[:state].eq(:is_published))
      else
        Board.arel_table[:visibility].eq(:is_public)
        .and(Board.arel_table[:state].eq(:is_published))
      end
    end

    def set_form
      @category_options = Category.all.order(name: :asc).map { |c| { value: c.id, label: c.name } }
      @tag_options = Tag.all.order(name: :asc).pluck(:name)
      @visibility_options = [ { value: :is_public, label: "Public" }, { value: :is_private, label: "Private" } ]
    end

    def authorize_author
      unless current_user == @board.author
        redirect_to boards_path, alert: "You can only modify your own boards."
      end
    end

    def board_params
      params.require(:board).permit(:category_id, :title, :body, :state, :visibility, tags: [])
    end

    def ensure_turbo_frame
      unless request.headers["Turbo-Frame"].present?
        redirect_to boards_path
      end
    end
end
