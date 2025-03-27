FactoryBot.define do
  factory :vote do
    voter { nil }
    votable { nil }
    is_upvote { false }
  end
end
