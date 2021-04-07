class Api::V1::InvoicesController < ApplicationController
  def unshipped_revenue
    quantity = (params[:quantity].nil? || params[:quantity] == 0) ? 10 : params[:quantity].to_i
    if quantity.to_i <= 0 #|| params[:quantity].class != Integer
      error = "invalid quantity parameter, it must be an integer greater than 0"
      render json: { error: error}, status: :bad_request
    else
      @invoice = Invoice.unshipped_potential_revenue(quantity)
      render json: UnshippedInvoiceSerializer.new(@invoice)
    end
  end
end
