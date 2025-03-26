class Comment < ApplicationRecord
  belongs_to :board
  belongs_to :commenter, class_name: "User"
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy

  # Maximum allowed depth for comments
  MAX_DEPTH = 5

  before_save :set_depth
  validate :check_depth_limit

  def top_level?
    parent_id.nil?
  end

  def all_replies_by_depth(depth)
    replies.where(depth: depth)
  end

  def all_replies
    replies.map { |reply| [ reply, reply.all_replies ] }.flatten
  end

  def as_json(options = {})
    super(options).merge(replies: replies.where("depth <= ?", MAX_DEPTH).map(&:as_json))
  end

  private

  def set_depth
    self.depth = parent ? parent.depth + 1 : 0
  end

  def check_depth_limit
    if depth > MAX_DEPTH
      errors.add(:depth, "cannot exceed #{MAX_DEPTH} levels")
    end
  end
end
