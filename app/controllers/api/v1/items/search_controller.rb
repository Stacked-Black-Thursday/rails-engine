class Api::V1::Items::SearchController < ApplicationController

  def show
    if params[:name] && (params[:min_price] || params[:max_price])
      render json: { error: "please send name or min and or max price" }, status: :bad_request
    elsif params[:name]
      search_term = params[:name].downcase
      item = Item.find_one_by_name_fragment(search_term)
      if item
        render json: ItemSerializer.new(item)
      else
        render json: {data: {}}
      end
    elsif params[:min_price] && params[:max_price]
      min_price = params[:min_price]
      max_price = params[:max_price]
      item = Item.where('unit_price <= ?', max_price ).where('unit_price >= ?', min_price).order(:name).limit(1).first
      if min_price > max_price
        render json: { error: "max price cannot less than 0"}, status: :bad_request
      elsif item
        render json: ItemSerializer.new(item)
      else
        render json: {data: {}}
      end
    elsif params[:max_price]
      max_price = params[:max_price].to_f
      item = Item.where('unit_price <= ?', max_price ).order(:name).limit(1).first
      if max_price < 0
        render json: { error: "max price cannot less than 0"}, status: :bad_request
      elsif item
        render json: ItemSerializer.new(item)
      else
        render json: {data: {}}
      end
    elsif params[:min_price]
      min_price = params[:min_price].to_f
      item = Item.where('unit_price >= ?', min_price).order(:name).limit(1).first
      if min_price < 0
        render json: { error: "min price cannot less than 0"}, status: :bad_request
      elsif item
        render json: ItemSerializer.new(item)
      else
        render json: {data: {}}
      end
    else
      render json: { error: "please send a query parameter"}, status: :bad_request
    end
  end
end
