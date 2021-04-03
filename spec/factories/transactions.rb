require 'date'
FactoryBot.define do
  factory :transaction do
    credit_card_number { '4444333322221111' }
    credit_card_expiration_date { Date.today }
    result { 'success' }
    invoice
  end
end
