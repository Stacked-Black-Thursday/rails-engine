FactoryBot.define do
  factory :invoice_item do
    quantity { 1 }
    unit_price { "9.99" }
    invoice { nil }
    item { nil }
  end
end
