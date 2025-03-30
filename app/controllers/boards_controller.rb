class BoardsController < ApplicationController
  before_action :set_board, only: %i[ show edit update destroy upvote downvote publish draft make_public make_private ]
  before_action :authenticate_user!, only: %i[ upvote downvote publish draft make_public make_private ]
  before_action :authorize_author, only: %i[ publish draft make_public make_private ]

  # GET /boards or /boards.json
  def index
    condition = { state: :is_published }
    unless user_signed_in?
      condition[:visibility] = :is_public
    end
    @boards = Board.where(condition)
    @categories = Category.joins(:boards).where(boards: condition).distinct
    @tags = Tag.joins(:boards).where(boards: condition).distinct
  end

  # GET /boards/1 or /boards/1.json
  def show
  end

  # GET /boards/new
  def new
    @board = Board.new
    @categories = Category.all
    @tags = Tag.all
  end

  # GET /boards/1/edit
  def edit
  end

  # POST /boards or /boards.json
  def create
    @board = Board.new(board_params)
    @board.author = current_user

    respond_to do |format|
      if @board.save
        format.html { redirect_to @board, notice: "Board was successfully created." }
        format.json { render :show, status: :created, location: @board }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boards/1 or /boards/1.json
  def update
    respond_to do |format|
      if @board.update(board_params)
        format.html { redirect_to @board, notice: "Board was successfully updated." }
        format.json { render :show, status: :ok, location: @board }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1 or /boards/1.json
  def destroy
    @board.destroy!

    respond_to do |format|
      format.html { redirect_to boards_path, status: :see_other, notice: "Board was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def upvote
    @board.upvote current_user
    redirect_to boards_path
  end

  def downvote
    @board.downvote current_user
    redirect_to boards_path
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
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params.expect(:id))
    end

    def authorize_author
      unless current_user == @board.author
        redirect_to boards_path, alert: "You can only modify your own boards."
      end
    end

    # Only allow a list of trusted parameters through.
    def board_params
      params.expect(board: [ :author_id, :category_id, :title, :body, :status, :upvotes_count, :views_count, :last_activity_at ])
    end
end
