class Board < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :category, optional: true

  has_many :taggings
  has_many :tags, through: :taggings
  has_many :comments, -> { where(parent_id: nil) }, dependent: :destroy

  def add_tag(tag_name)
    tag = Tag.find_or_create_by(name: tag_name)
    unless tags.include?(tag)
      taggings.create(tag: tag)
    end
  end

  def remove_tag(tag_name)
    tag = Tag.find_by(name: tag_name)
    if tag && tags.include?(tag)
      taggings.find_by(tag: tag).destroy
      if tag.boards.empty?
        tag.destroy
      end
    end
  end
end
