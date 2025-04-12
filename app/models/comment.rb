class Comment < ApplicationRecord
  include Votable

  belongs_to :board
  belongs_to :commenter, class_name: "User"
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy

  # Maximum allowed depth for comments
  MAX_DEPTH = 2

  before_validation :set_depth
  validate :check_depth_limit

  validates :body, presence: true

  def top_level?
    parent_id.nil?
  end

  def is_max_depth?
    depth >= MAX_DEPTH
  end

  def is_commenter?(user)
    commenter == user
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
