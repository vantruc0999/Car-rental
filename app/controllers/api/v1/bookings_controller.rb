class Api::V1::BookingsController < ApiController
    before_action :set_car, only: %i[create]

    include ApiResponse
    include BookingsHelper

    def create
        # data= Booking.where(user_id: current_user.id)
        #         .where.not(car_id: @car.id)
        #         .where(booking_status: [10, 11, 12, 30])
        #         .where('(booking_start BETWEEN ? AND ?) OR (booking_end BETWEEN ? AND ?)', 
        #         params[:booking_start], params[:booking_end],
        #         params[:booking_start], params[:booking_end])
        #         .first
        # data = calculate_car_price(@car.price_per_hour, params[:booking_start],  params[:booking_end])
        # return render json:{data: data}
        begin
          ActiveRecord::Base.transaction do
            inputs = booking_params
            user_id = current_user.id
            car_name = @car.name
      
            existing_bookings = Booking.where(car_id: inputs[:car_id])
              .where.not(booking_status: [10, 20])
              .where("(booking_start BETWEEN ? AND ?) OR (booking_end BETWEEN ? AND ?)",
                     params[:booking_start], params[:booking_end],
                     params[:booking_start], params[:booking_end])
              .to_a
      
            if existing_bookings.present?
                return render_error('Car already booked')
            end

            existing_booking_of_user = Booking.where(user_id: user_id)
                .where.not(car_id: @car.id)
                .where(booking_status: [10, 11, 12, 30])
                .where('(booking_start BETWEEN ? AND ?) OR (booking_end BETWEEN ? AND ?)', 
                    params[:booking_start], params[:booking_end],
                    params[:booking_start], params[:booking_end])
                .first

            if existing_booking_of_user.present?
                return render_error('Booking already exists')
            end

            car_price = calculate_car_price(@car.price_per_hour, params[:booking_start],  params[:booking_end])
            
            data = {}

            render_success(data, 'Booking success')
          end
        rescue StandardError => e
          render_error('Booking failed')
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
        params.permit(:car_id, :booking_start, :booking_end)
    end 
end
