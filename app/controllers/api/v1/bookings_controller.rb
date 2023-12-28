class Api::V1::BookingsController < ApiController
    before_action :set_car, only: %i[create]

    include ApiResponse
    include BookingsHelper

    def create
        begin
          ActiveRecord::Base.transaction do
            inputs = booking_params
            user_id = current_user.id
            car_name = @car.name
      
            # existing_bookings = Booking.where(car_id: inputs[:car_id])
            #   .where.not(booking_status: [10, 20])
            #   .where("(booking_start BETWEEN ? AND ?) OR (booking_end BETWEEN ? AND ?)",
            #          params[:booking_start], params[:booking_end],
            #          params[:booking_start], params[:booking_end])
            #   .to_a
      
            # if existing_bookings.present?
            #     return render_error('Car already booked')
            # end

            params[:booking_start] = Time.parse(params[:booking_start])
            params[:booking_end] = Time.parse(params[:booking_end])

            existing_booking_holding = Booking::where(user_id: user_id)
                .where.not(car_id: params[:car_id])
                .where(booking_status: 11)
                .where('(booking_start BETWEEN ? AND ?) OR (booking_end BETWEEN ? AND ?)',
                    params[:booking_start], params[:booking_end],
                    params[:booking_start], params[:booking_end])
                .first

            if existing_booking_holding 
                return render_error('Booking holding already exists') 
            end
            
            existing_booking_in_time = Booking::where(user_id: user_id)
                .where.not(car_id: params[:car_id])
                .where(booking_status: [12, 20])    
                .where('(booking_start <= ? AND booking_end >= ?) OR (booking_start <= ? AND booking_end >= ?)',
                        params[:booking_end], params[:booking_start],
                        params[:booking_start], params[:booking_end])
                .first

            if existing_booking_in_time 
                return render_error('Booking in time already exists') 
            end

            car_price = calculate_car_price(@car.price_per_hour, params[:booking_start],  params[:booking_end])

            # existing_booking = Booking.where(user_id: user_id)
            #     .where(car_id: @car.id)
            #     .where('(booking_start BETWEEN ? AND ?) OR (booking_end BETWEEN ? AND ?)', 
            #         params[:booking_start], params[:booking_end],
            #         params[:booking_start], params[:booking_end])
            #     .first

            if(existing_booking)
                current_time = Time.current
                expired_time = existing_booking.expired_at
                time_difference = (expired_time - current_time).to_i

                if(time_difference < 10 * 60)
                    return render_success(existing_booking, 'Booking was successful')
                end
            end

            params['user_id'] = user_id
            params['car_price'] = car_price
            params['booking_status'] = 10
            params['has_insurance'] = 1
            params['expired_at'] = Time.zone.now + 10.minutes

            @booking = Booking.new(booking_params)

            if @booking.save 
                @car.update(status: 1)
                expiry = Time.zone.now + 10.minutes
                # CancelExpiredBookingJob.perform_in(expiry, @booking.id)
                render_success(@booking, 'Booking was successful')
            else
                render_error(@booking, 'Booking was failed')
            end
          end
        rescue StandardError => e
          return render json:{e: e}
          render_error('Booking failed')
        end
    end

    def create_review
        car_id = params['car_id']
        rating = params['rating']
        comment = params['comment']
        user = current_user

        booking = Booking.where(car_id: car_id)
                    .where(user_id: user.id)
                    .where(booking_status: 30)
                    .first

        return render_error('Booking not found') unless booking
        
        review = Review.where(booking_id: booking.id).first

        if review
            return render_error('Review already existed')
        end

        @review = Review.new(
            user_id: user.id,
            car_id: car_id,
            rating: rating,
            comment: comment,
            booking_id: booking.id
        )

        if @review.save
            return render_success(@review, 'Review was successful')
        else
            return render_error('Failed to review')
        end
    end

    private

    def set_car
        @car = Car.find_by(id: params[:car_id])

        if !@car
            render_error("Car not found")
        end
    end

    def booking_params
        params.permit(:car_id, :booking_start, :booking_end, :user_id, :car_price, 
                        :booking_status, :has_insurance, :expired_at )
    end 
end
