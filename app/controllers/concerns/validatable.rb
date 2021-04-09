module Validatable
  extend ActiveSupport::Concern

  def quantity
    params[:quantity].nil? ? 10 : params[:quantity].to_i
  end

  def invalid_quantity?
    quantity.to_i <= 0
  end

  def quantity_nil?
    params[:quantity].nil?
  end

  def name
    params[:name]
  end

  def min_price
    params[:min_price]
  end

  def max_price
    params[:max_price]
  end

  def min_or_max?
    max_price || min_price
  end

  def invalid_query_params?
    return true if query_params_nil?
    return true if name && (min_price || max_price)
    invalid_min_max_price?
  end

  def query_params_nil?
    params[:name].nil? && params[:max_price].nil? && params[:min_price].nil?
  end

  def invalid_min_max_price?
    return true if min_price.to_f < 0
    return true if max_price.to_f < 0
    if min_price && max_price
      min_price.to_f > max_price.to_f
    end
  end
end
