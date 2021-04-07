class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  def self.destroy_invoice_only_one_item(item_id)
    item_invoices = Item.find(item_id).invoices
    invoice_ids = item_invoices.joins(:invoice_items).select(:id).group(:id).having('count(invoice_items.item_id) <= 1').pluck(:id)
    Invoice.destroy(invoice_ids)
  end

  def self.unshipped_potential_revenue(quantity)
    select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as potential_revenue')
    .joins(:invoice_items)
    .where('invoices.status = ?', 'packaged')
    .group('invoices.id')
    .order('potential_revenue desc')
    .limit(quantity)
    # .round(2)
  end
end
