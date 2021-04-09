class Api::V1::Items::SearchController < ApplicationController
  include Validatable

  def show
    error = "please send a valid query parameter"
    return render_error(error) if invalid_query_params?
    return success_response(Item.find_one_by_name_fragment(name.downcase)) if name
    success_response(Item.find_one_by_unit_price(min_price, max_price))
  end

  private

  def success_response(item)
    item ? (render_success(ItemSerializer, item)) : (render json: {data: {}})
  end
end
