class Board < ApplicationRecord
  include Votable

  belongs_to :author, class_name: "User"
  belongs_to :category, optional: true

  has_many :taggings
  has_many :tags, through: :taggings
  has_many :comments, dependent: :destroy

  def comments_by_depth(depth)
    comments.where(depth: depth)
  end

  enum :state, { is_draft: 0, is_published: 1 } do
    event :publish do
      transition is_draft: :is_published
    end

    event :draft do
      transition is_published: :is_draft
    end
  end

  enum :visibility, { is_private: 0, is_public: 1 } do
    event :make_private do
      transition is_public: :is_private
    end

    event :make_public do
      transition is_private: :is_public
    end
  end

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

  def is_author?(user)
    author == user
  end
end
