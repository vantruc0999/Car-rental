class CancelExpiredBookingJob
    include Sidekiq::Job
    queue_as :default
  
    def perform(booking_id)
      booking = Booking.find_by(id: booking_id)
  
      return unless booking
  
      expired_at = booking.expired_at
  
      return if expired_at > Time.zone.now
  
      return unless [10, 11].include?(booking.booking_status)
  
      ActiveRecord::Base.transaction do
        related_car = Car.find_by(id: booking.car_id)
  
        related_car&.update(status: 0) if related_car
  
        booking.destroy

        puts "Destroy booking was successful"
      end
    rescue StandardError => e
      Rails.logger.error("Error in CancelExpiredBookingJob: #{e.message}")
    end
  end