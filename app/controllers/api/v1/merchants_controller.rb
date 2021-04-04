class Api::V1::MerchantsController < ApplicationController

  def index
    page = params[:page] && params[:page].to_i >= 1 ? params.fetch(:page).to_i : 1
    per_page = params[:per_page] ? params.fetch(:per_page).to_i : 20
    render json: MerchantSerializer.new(Merchant.limit(per_page).offset((page - 1) * per_page))
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end
end
