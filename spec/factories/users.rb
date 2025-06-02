FactoryBot.define do
  factory :user do
    nickname { Faker::Internet.username(specifier: 8) }
  end
end
