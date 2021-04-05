class Api::V1::Merchants::MerchantItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
  end
end
