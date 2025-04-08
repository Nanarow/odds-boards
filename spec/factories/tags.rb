FactoryBot.define do
  factory :tag do
    creator { association :user }
    sequence(:name) { |n| "Tag #{n}" }
  end
end
