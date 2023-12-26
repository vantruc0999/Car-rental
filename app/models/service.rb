class Service < ApplicationRecord
    has_many :booking_services
    has_many :bookings, through: :booking_services
end
