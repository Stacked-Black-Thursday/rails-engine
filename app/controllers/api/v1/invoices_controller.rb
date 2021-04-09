class Api::V1::InvoicesController < ApplicationController
  include Validatable

  def unshipped_revenue
    error = "invalid quantity parameter, it must be an integer greater than 0"
    return render_error(error, :bad_request) if invalid_quantity?
    invoices = Invoice.unshipped_potential_revenue(quantity)
    render_success(UnshippedInvoiceSerializer, invoices)
  end
end
