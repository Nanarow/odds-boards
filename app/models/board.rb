class Board < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :category, optional: true
end
