# app/serializers/car_serializer.rb
class CarSerializer < ActiveModel::Serializer
  # attributes :brand_id, :car_model_id, :name, :year, :color,
  # :description, :address, :province, :seating_capacity, :fuel_type, :price_per_hour

  # belongs_to :brand
  # belongs_to :car_model

  # def brand_name
  #   object.brand.name if object.brand
  # end
  def initialize(object, response_type: 'default')
    @response_type = response_type
    super(object)
  end

  def average_rating
    object.reviews.average(:rating).to_f.round(1)
  end

  def total_reviews
    object.reviews.count
  end

  def serializable_hash(*args)
    if @response_type == 'detail'
      detail_response
    elsif @response_type == 'recommended'
      recommended_response
    else
      default_response
    end
  end

  private

  def default_response
    {
      id: object.id,
      name: object.name,
      brand: BrandSerializer.new(object.brand).serializable_hash,
      car_model: CarModelSerializer.new(object.car_model).serializable_hash,
      seating_capacity: object.seating_capacity,
      address: object.address,
      province: object.province,
      price_per_day: object.price_per_hour,
      average_rating: average_rating,
      total_reviews: total_reviews
    }
  end

  def detail_response
    {
      id: object.id,
      name: object.name,
      brand: BrandSerializer.new(object.brand).serializable_hash,
      car_model: CarModelSerializer.new(object.car_model).serializable_hash,
      status: object.status,
      address: object.address,
      overview: object.description,
      price_per_day: object.price_per_hour,
      reviews: {
        total_reviews: total_reviews,
        average_rating: average_rating
      }
    }
  end
end

