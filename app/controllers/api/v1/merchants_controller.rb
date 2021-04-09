class Api::V1::MerchantsController < ApplicationController
  include Validatable

  before_action :pagination, only: :index

  def index
    merchants = Merchant.limit(@per_page).offset((@page - 1) * @per_page)
    render_success(MerchantSerializer, merchants)
  end

  def show
    render_success(MerchantSerializer, Merchant.find(params[:id]))
  end

  def revenue_by_merchant
    render_success(MerchantRevenueSerializer, Merchant.find(params[:id]))
  end

  def most_revenue
    error = "invalid quantity parameter, it must be an integer greater than 0"
    return render_error(error) if quantity_nil? || valid_quantity?
    merchants = Merchant.top_revenue(quantity)
    render_success(MerchantNameRevenueSerializer, merchants)
  end
end
