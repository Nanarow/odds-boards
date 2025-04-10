class Board < ApplicationRecord
  include Votable

  belongs_to :author, class_name: "User"
  belongs_to :category, optional: true

  has_many :taggings
  has_many :tags, through: :taggings
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

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

  def set_tags(tag_names, creator)
    current_tags = tags.pluck(:name)
    tags_to_add = tag_names - current_tags
    tags_to_remove = current_tags - tag_names
    add_tags(tags_to_add, creator)
    remove_tags(tags_to_remove)
  end

  def add_tags(tag_names, creator)
    existing_tag_ids = tags.pluck(:id).to_set

    tag_names.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name) { |t| t.creator = creator }
      unless existing_tag_ids.include?(tag.id)
        taggings.create(tag: tag)
        existing_tag_ids.add(tag.id)
      end
    end
  end

  def remove_tags(tag_names)
    tag_names.each do |tag_name|
      tag = Tag.find_by(name: tag_name)
      next unless tag
      taggings.find_by(tag: tag)&.destroy
      tag.destroy if tag.boards.empty?
    end
  end

  def is_author?(user)
    author == user
  end

  before_destroy :remember_tags
  after_destroy :cleanup_unused_tags

  private

  def remember_tags
    @tags_to_check = tags.to_a
    taggings.destroy_all
  end

  def cleanup_unused_tags
    @tags_to_check.each do |tag|
      tag.destroy if tag.boards.empty?
    end
  end
end
