FactoryBot.define do
  factory :recipe do
    title { Faker::Food.dish }
    text { Faker::Food.description }
    difficulty { Recipe.difficulties.keys.sample }
    preparation_time { rand(1..120) }
    featured { false }
    author
  end
end
