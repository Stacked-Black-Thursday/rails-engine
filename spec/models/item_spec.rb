require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:transactions).through(:invoices)}
    it {should have_many(:customers).through(:invoices)}
  end

  describe 'validations' do
    it {should validate_presence_of(:name).on(:create)}
    it {should validate_presence_of(:description).on(:create)}
    it {should validate_presence_of(:unit_price).on(:create)}
    it {should validate_presence_of(:merchant_id).on(:create)}
  end
end
