class Api::V1::Merchants::SearchController < ApplicationController

  def index
    search_term = params[:name].downcase
    merchant = Merchant.where("lower(name) like ?", '%' + search_term + '%').order(:name)
    render json: MerchantSerializer.new(merchant)
  end
end
