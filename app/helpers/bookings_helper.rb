# app/helpers/booking_helper.rb
module BookingsHelper
    def calculate_car_price(price_per_hour, booking_start, booking_end)
      booking_start = Time.zone.parse(booking_start)
      booking_end = Time.zone.parse(booking_end)
      hours = ((booking_end - booking_start) / 1.hour).round
      price_per_hour * hours
    end
end
  