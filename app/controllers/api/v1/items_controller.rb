class Api::V1::ItemsController < ApplicationController
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
    if item.save
      render_success(ItemSerializer, item, :created)
    else
      render_error(item.errors.full_messages, :not_acceptable)
    end
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render_success(ItemSerializer, item, :accepted)
    else
      render_error(item.errors.full_messages)
    end
  end

  def destroy
    item = Item.find(params[:id])
    invoices = Invoice.invoices_only_one_item(item.id)
    Invoice.destroy(invoices)
    Item.destroy(item.id)
  end

  def most_revenue
    quantity = params[:quantity].nil? ? 10 : params[:quantity].to_i
    if quantity.to_i <= 0
      error = "invalid quantity parameter, it must be an integer greater than 0"
      render_error(error)
    else
      items = Item.top_revenue(quantity)
      render_success(ItemRevenueSerializer, items)
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
