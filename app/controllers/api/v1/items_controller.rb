class Api::V1::ItemsController < ApplicationController
  include Validatable

  before_action :pagination, only: :index

  def index
    items = Item.limit(@per_page).offset((@page - 1) * @per_page)
    render_success(ItemSerializer, items)
  end

  def show
    item = Item.find(params[:id])
    render_success(ItemSerializer, item)
  end

  def create
    item = Item.new(item_params)
    return render_success(ItemSerializer, item, :created) if item.save
    render_error(item.errors.full_messages, :not_acceptable)
  end

  def update
    item = Item.find(params[:id])
    return render_success(ItemSerializer, item, :accepted) if item.update(item_params)
    render_error(item.errors.full_messages)
  end

  def destroy
    item = Item.find(params[:id])
    invoices = Invoice.invoices_only_one_item(item.id)
    Invoice.destroy(invoices)
    Item.destroy(item.id)
  end

  def most_revenue
    error = "quantity must be an integer greater than 0"
    return render_error(error) if valid_quantity?
    render_success(ItemRevenueSerializer, Item.top_revenue(quantity))
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
