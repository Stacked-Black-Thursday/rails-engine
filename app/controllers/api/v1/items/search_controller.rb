class Api::V1::Items::SearchController < ApplicationController

  def show
    min_price = params[:min_price]
    max_price = params[:max_price]
    name = params[:name]

    if name && (min_price || max_price)
      error = "please send name or price parameter, you cannot send both"
      render_error(error)
    elsif name
      search_by_name(name.downcase)
    elsif min_price && max_price
      search_by_min_and_max_price(min_price, max_price)
    elsif max_price
      search_by_max_price(min_price, max_price)
    elsif min_price
      search_by_min_price(min_price, max_price)
    else
      error = "please send a query parameter"
      render_error(error)
    end
  end

  private

  def success_response(item)
    item ? (render_success(ItemSerializer, item)) : (render json: {data: {}})
  end

  def search_by_name(name)
    success_response(Item.find_one_by_name_fragment(name))
  end
  #
  # def validate_min_max_price(min_price, max_price)
  #   return true if min_price.to_f < 0
  #   return true if max_price.to_f < 0
  #   return true if min_price > max_price
  # end

  def search_by_min_price(min_price, max_price)
    item = Item.find_one_by_unit_price(min_price, max_price)
    error = "price cannot less than 0"
    min_price.to_f < 0 ? render_error(error) : success_response(item)
  end

  def search_by_max_price(min_price, max_price)
    item = Item.find_one_by_unit_price(min_price, max_price)
    error = "price cannot less than 0"
    max_price.to_f < 0 ? render_error(error) : success_response(item)
  end

  def search_by_min_and_max_price(min_price, max_price)
    item = Item.find_one_by_unit_price(min_price, max_price)
    error = "min price cannot greater than max price"
    min_price > max_price ? render_error(error) : success_response(item)
  end
end
