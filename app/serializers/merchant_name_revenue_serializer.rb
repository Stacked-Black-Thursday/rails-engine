class MerchantNameRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name

  attribute :revenue do |object|
    object.revenue.to_f
  end
end
