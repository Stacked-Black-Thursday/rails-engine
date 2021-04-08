require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it {should have_many :items}
    it {should have_many(:invoice_items).through(:items)}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:transactions).through(:invoices)}
    it {should have_many(:customers).through(:invoices)}
  end

  describe 'class methods' do
    describe '::find_all_by_name_fragment' do
      it "returns all merchants based on a partial name search" do
        merchant1 = create(:merchant, name: "Fancy Merchant")
        merchant2 = create(:merchant, name: "A Really Fancy Merchant")
        merchant3 = create(:merchant, name: "Merchant Name")
        fragment = 'fancy'

        expect(Merchant.find_all_by_name_fragment(fragment)).to eq([merchant2, merchant1])
        expect(Merchant.find_all_by_name_fragment(fragment).include?(merchant3)).to eq(false)
      end
    end

    describe '::top_revenue' do
      before :each do
        seed_test_db
      end
      it "returns the merchants ranked by top revenue limited based on number provided" do
        quantity = 5
        results = Merchant.top_revenue(quantity)

        expect(results.first.revenue).to eq(0.114e5)
        expect(results.last.revenue).to eq(0.3e3)
        expect(results.size).to eq(5)

        quantity = 100
        results = Merchant.top_revenue(quantity)

        expect(results.first.revenue).to eq(0.114e5)
        expect(results.last.revenue).to eq(0.1e1)
        expect(results.size).to eq(11)
      end
    end
  end

  describe 'instance methods' do
    before :each do
      seed_test_db
    end
    it "returns total revenue for a single merchant given" do
      merchant = @merchant10
      results = merchant.total_revenue

      expect(results).to eq(0.25e3)
    end
  end
end
