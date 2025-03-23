class Tagging < ApplicationRecord
  belongs_to :board
  belongs_to :tag
end
