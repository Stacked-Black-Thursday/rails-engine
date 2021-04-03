FactoryBot.define do
  factory :item do
    name { Faker::Dessert.variety }
    description { Faker::GreekPhilosophers.quote }
    sequence :unit_price do |n|
      n + 10
    end
    merchant
  end
end
