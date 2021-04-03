FactoryBot.define do
  factory :customer do
    first_name { Faker::Games::SuperMario.character }
    last_name { Faker::Games::StreetFighter.character }
  end
end
