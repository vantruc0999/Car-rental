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
      begin
        booking_cancellation = Cancellation.find_or_initialize_by(booking_id: booking_id)
        booking_cancellation.update(
          cancellation_reason: 'Payment expired',
          refund_amount: 0,
          refund_status: 0
        )

        payment = Payment.find_by(booking_id: booking.id)

        if payment.payment_method == 0 && booking.booking_status == 11
          booking_cancellation.update(
            refund_status: 2
          )
        end

        payment.update(
          payment_status: 2
        )

        booking.update(
          booking_status: 40,
          expired_at: Time.now
        )

        car = Car.find_by(id: booking.car_id)
        car.update(
          status: 0
        )

      rescue StandardError => e
        Rails.logger.error("Error in CancelExpiredBooking job: #{e.message}")
        raise ActiveRecord::Rollback
      end

      # related_car = Car.find_by(id: booking.car_id)

      # related_car&.update(status: 0) if related_car

      # booking.destroy

      puts "Destroy booking was successful"
    end
  rescue StandardError => e
    Rails.logger.error("Error in CancelExpiredBookingJob: #{e.message}")
  end
end
