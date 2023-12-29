class Booking < ApplicationRecord
    belongs_to :user
    belongs_to :car
    has_one :payment
    has_one :cancellation
    has_many :booking_services
    has_many :services, through: :booking_services
end
