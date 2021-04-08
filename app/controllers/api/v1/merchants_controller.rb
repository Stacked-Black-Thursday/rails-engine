class Api::V1::MerchantsController < ApplicationController

  def index
    page = params[:page] && params[:page].to_i >= 1 ? params.fetch(:page).to_i : 1
    per_page = params[:per_page] ? params.fetch(:per_page).to_i : 20
    render json: MerchantSerializer.new(Merchant.limit(per_page).offset((page - 1) * per_page))
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
