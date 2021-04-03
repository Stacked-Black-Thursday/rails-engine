FactoryBot.define do
  factory :invoice_item do
    sequence :quantity do |n|
      n * 3
    end
    sequence :unit_price do |n|
      n * 2
    end
    invoice
    item
  end
end
