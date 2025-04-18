class BoardsController < ApplicationController
  before_action :set_board, only: %i[ edit update destroy upvote show cancel_edit confirm_delete ]
  before_action :authenticate_user!, only: %i[ upvote my_boards ]
  before_action :authorize_author, only: %i[ edit update destroy ]
  before_action :set_form, only: %i[ new edit ]
  before_action :set_categories, only: %i[ index my_boards show ]
  before_action :set_tags, only: %i[ index my_boards show ]
  # before_action :ensure_turbo_frame, only: [ :new ]

  def index
    condition = { state: :is_published, visibility: :is_public }
    condition.delete(:visibility) if user_signed_in?
    set_boards(condition)
  end

  def my_boards
    set_boards author: current_user
  end

  def search
    path = URI(request.referer || "").path
    if path == boards_path
      index
    elsif path == my_boards_path
      my_boards
    end
  end

  def sort
    search
  end

  def show
    @comments = @board.comments_by_depth(0)
  end

  def new
    @board = Board.new
  end

  def edit
  end

  def cancel_edit
  end

  def cancel_new
  end

  def confirm_delete
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
      @boards = Board.where(condition)
      @query = params[:query]
      @sort_by = params[:sort_by].presence_in(%w[title created_at updated_at]) || "created_at"
      @direction = params[:direction].presence_in(%w[asc desc]) || "desc"
      if @query.present? && !@query.blank?
        @boards = @boards.search(@query)
      end
      @boards = @boards.order(@sort_by => @direction).includes(:author, :category, :tags, :comments, :votes)
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
