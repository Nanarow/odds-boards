class Tag < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :taggings
  has_many :boards, through: :taggings

  before_save :normalize_name

  private

  def normalize_name
    self.name = name.strip.downcase.humanize if name.present?
  end
end
