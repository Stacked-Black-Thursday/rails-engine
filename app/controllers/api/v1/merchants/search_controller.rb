class Api::V1::Merchants::SearchController < ApplicationController

  def index
    search_term = params[:name].downcase
    render json: MerchantSerializer.new(Merchant.find_all_by_name_fragment(search_term))
  end
end
