class Comment < ApplicationRecord
  belongs_to :board
  belongs_to :commenter, class_name: "User"
  belongs_to :parent, class_name: "Comment", optional: true

  has_many :replies, class_name: "Comment", foreign_key: "parent_id"

  before_save :set_depth

  def top_level?
    parent_id.nil?
  end

  def all_replies_by_depth(depth)
    replies.where(depth: depth)
  end

  def all_replies
    replies.map { |reply| [ reply, reply.all_replies ] }.flatten
  end

  private
  def set_depth
    self.depth = parent ? parent.depth + 1 : 0
  end
end
