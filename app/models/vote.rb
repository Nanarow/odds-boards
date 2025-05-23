class Vote < ApplicationRecord
  belongs_to :voter, class_name: "User"
  belongs_to :votable, polymorphic: true

  validates :is_upvote, inclusion: { in: [ true, false ] }
end
