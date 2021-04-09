class Api::V1::MerchantsController < ApplicationController
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
    quantity = params[:quantity].to_i if params[:quantity]
    if quantity.to_i <= 0 || params[:quantity].nil?
      error = "invalid quantity parameter, it must be an integer greater than 0"
      render_error(error)
    else
      merchants = Merchant.top_revenue(quantity)
      render_success(MerchantNameRevenueSerializer, merchants)
    end
  end
end
