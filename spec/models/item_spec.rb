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

  describe 'class methods' do
    describe '::find_one_by_name_fragment' do
      it "it returns one item by partial name search" do
        item1 = create(:item, name: "Fancy Item Name")
        item2 = create(:item, name: "A Really Fancy Item Name")
        item3 = create(:item, name: "Not Fancy Item Name")
        fragment = 'fancy'

        expect(Item.find_one_by_name_fragment(fragment)).to eq(item2)
      end
    end

    describe '::find_one_by_unit_price' do
      it "returns one item by unit price between a min and max, ordered alphabetically" do
        item1 = create(:item, name: "B Item", unit_price: 100.99)
        item2 = create(:item, name: "A Item", unit_price: 109.99)
        item3 = create(:item, name: "C Item", unit_price: 300.99)
        min_price = 100
        max_price = 200.00

        expect(Item.find_one_by_unit_price(min_price, max_price)).to eq(item2)
      end
    end

    describe '::top_revenue' do
      before :each do
        seed_test_db
      end
      it "returns the total revenue for items limiting the results based on number provided" do
        quantity = 10
        results = Item.top_revenue(quantity)

        expect(results.first.revenue).to eq(0.114e5)
        expect(results.last.revenue).to eq(0.1e3)
        expect(results.size).to eq(10)
      end
    end
  end
end
