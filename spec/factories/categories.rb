FactoryBot.define do
  factory :category do
    creator { association :user }
    sequence(:name) { |n| "Category #{n}" }
    description { "Description" }
  end
end
