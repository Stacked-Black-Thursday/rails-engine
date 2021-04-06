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
  end
end
