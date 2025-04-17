FactoryBot.define do
  factory :board do
    author { nil }
    category { nil }
    state { :is_published }
    visibility { :is_public }
    title { "MyString" }
    body { "MyText" }
  end
end
