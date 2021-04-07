require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it {should belong_to :customer}
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many :transactions}
    it {should have_many(:items).through(:invoice_items)}
    it {should have_many(:merchants).through(:items)}
  end

  describe 'class methods' do
    describe '::destroy_invoice_only_one_item' do
      it "it destroys any invoice that has only a single item when that item is destroyed" do
        invoices = create_list(:invoice, 2)
        items = create_list(:item, 2)
        invoice_1 = invoices.first
        invoice_2 = invoices.last
        item_1 = items.first
        item_2 = items.last
        invoice_1.items << item_1
        invoice_2.items << item_1
        invoice_2.items << item_2
        Invoice.destroy_invoice_only_one_item(item_1.id)

        expect{ Invoice.find(invoice_1.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect(Invoice.find(invoice_2.id)).to eq(invoice_2)
      end
    end

    describe '::unshipped_potential_revenue' do
      before :each do
        seed_test_db
      end
      it "returns total revenue for a defined quantity of invoices with packaged status" do
        results = Invoice.unshipped_potential_revenue(100)

        expect(results.first).to eq(@invoice6)
        expect(results.first.potential_revenue).to eq(0.2077e5)
        expect(results.last).to eq(@invoice16)
        expect(results.last.potential_revenue).to eq(0.1e3)
        expect(results.pluck(:id).size).to eq(11)
      end
    end
  end
end
