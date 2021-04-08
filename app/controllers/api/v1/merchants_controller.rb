class Api::V1::MerchantsController < ApplicationController
  before_action :pagination, only: :index

  def index
    merchants = Merchant.limit(@per_page).offset((@page - 1) * @per_page)
    render json: MerchantSerializer.new(merchants)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def revenue_by_merchant
    @merchant = Merchant.find(params[:id])
    render json: MerchantRevenueSerializer.new(@merchant)
  end

  def most_revenue
    quantity = params[:quantity].to_i if params[:quantity]
    if quantity.to_i <= 0 || params[:quantity].nil?
      error = "invalid quantity parameter, it must be an integer greater than 0"
      render json: { error: error}, status: :bad_request
    else
      @merchants = Merchant.top_revenue(quantity)
      render json: MerchantNameRevenueSerializer.new(@merchants)
    end
  end
end
