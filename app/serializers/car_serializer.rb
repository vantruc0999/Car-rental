class CarSerializer < ActiveModel::Serializer
  attributes :brand_id, :car_model_id, :name, :year, :color,
  :description, :address, :province, :seating_capacity, :fuel_type, :price_per_hour

  belongs_to :brand
  belongs_to :car_model

  def brand_name
    object.brand.name if object.brand
  end
end
