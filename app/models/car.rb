class Car < ApplicationRecord  
    belongs_to :brand
    belongs_to :car_model
    has_many :bookings, foreign_key: 'car_id'
    has_many :reviews, foreign_key: 'car_id'
  
    enum status: { active: 0, inactive: 1 }
  
    validates :brand_id, :car_model_id, :name, :year, :color, :status, :description,
              :seating_capacity, :fuel_type, :price_per_hour,
              :address, :province, presence: true
  
    validates :status, inclusion: { in: %w[active inactive] }
  
    scope :active_cars, -> { where(status: 'active') }
    
end
  