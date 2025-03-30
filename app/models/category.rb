class Category < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :boards, dependent: :destroy
end
