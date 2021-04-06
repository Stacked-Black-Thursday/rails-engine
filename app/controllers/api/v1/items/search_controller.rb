class Api::V1::Items::SearchController < ApplicationController

  def show
    if params[:name] && (params[:min_price] || params[:max_price])
      render json: { error: "please send name or min and or max price" }, status: :bad_request
    elsif params[:name]
      search_term = params[:name].downcase
      search_by_name(search_term)
    elsif params[:min_price] && params[:max_price]
      min_price = params[:min_price]
      max_price = params[:max_price]
      search_by_min_and_max_price(min_price, max_price)
    elsif params[:max_price]
      max_price = params[:max_price].to_f
      search_by_max_price(max_price)
    elsif params[:min_price]
      min_price = params[:min_price].to_f
      search_by_min_unit_price(min_price)
    else
      render json: { error: "please send a query parameter"}, status: :bad_request
    end
  end

  private

  def search_by_name(search_term)
    item = Item.find_one_by_name_fragment(search_term)
    if item
      render json: ItemSerializer.new(item)
    else
      render json: {data: {}}
    end
  end

  def search_by_min_unit_price(min_price)
    item = Item.find_one_by_unit_price(min_price)
    if min_price < 0
      render json: { error: "min price cannot less than 0"}, status: :bad_request
    elsif item
      render json: ItemSerializer.new(item)
    else
      render json: {data: {}}
    end
  end

  def search_by_max_price(max_price)
    item = Item.find_one_by_unit_price(max_price)
    if max_price < 0
      render json: { error: "max price cannot less than 0"}, status: :bad_request
    elsif item
      render json: ItemSerializer.new(item)
    else
      render json: {data: {}}
    end
  end

  def search_by_min_and_max_price(min_price, max_price)
    item = Item.find_one_by_unit_price(min_price, max_price)
    if min_price > max_price
      render json: { error: "max price cannot less than 0"}, status: :bad_request
    elsif item
      render json: ItemSerializer.new(item)
    else
      render json: {data: {}}
    end
  end
end
