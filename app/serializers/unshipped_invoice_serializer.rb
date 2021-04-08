class UnshippedInvoiceSerializer
  include FastJsonapi::ObjectSerializer

  attribute :potential_revenue do |object|
    object.potential_revenue.to_f
  end
end
