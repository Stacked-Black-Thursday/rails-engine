class Api::V1::Items::SearchController < ApplicationController

  def show
    min_price = params[:min_price]
    max_price = params[:max_price]
    name = params[:name]

    if name && (min_price || max_price)
      error = "please send name or price parameter, you cannot send both"
      failed_response(error)
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
      failed_response(error)
    end
  end

  private

  def success_response(item)
    item ? (render json: ItemSerializer.new(item)) : (render json: {data: {}})
  end

  def failed_response(error)
    render json: { error: error}, status: :bad_request
  end

  def search_by_name(name)
    success_response(Item.find_one_by_name_fragment(name))
  end

  def search_by_min_price(min_price, max_price)
    item = Item.find_one_by_unit_price(min_price, max_price)
    error = "price cannot less than 0"
    min_price.to_f < 0 ? failed_response(error) : success_response(item)
  end

  def search_by_max_price(min_price, max_price)
    item = Item.find_one_by_unit_price(min_price, max_price)
    error = "price cannot less than 0"
    max_price.to_f < 0 ? failed_response(error) : success_response(item)
  end

  def search_by_min_and_max_price(min_price, max_price)
    item = Item.find_one_by_unit_price(min_price, max_price)
    error = "min price cannot greater than max price"
    min_price > max_price ? failed_response(error) : success_response(item)
  end
end
