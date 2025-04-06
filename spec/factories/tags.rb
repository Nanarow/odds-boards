FactoryBot.define do
  factory :tag do
    creator { association :user }
    name { "MyString" }
  end
end
