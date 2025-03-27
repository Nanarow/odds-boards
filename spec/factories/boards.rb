FactoryBot.define do
  factory :board do
    author { nil }
    category { nil }
    title { "MyString" }
    body { "MyText" }
    views_count { 1 }
    last_activity_at { "2025-03-23 13:09:31" }
  end
end
