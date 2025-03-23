FactoryBot.define do
  factory :comment do
    board { nil }
    commenter { nil }
    parent { nil }
    body { "MyText" }
    depth { 1 }
  end
end
