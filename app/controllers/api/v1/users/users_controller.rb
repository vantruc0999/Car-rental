class Api::V1::Users::UsersController < ApiController
    include ApiResponse

    def get_user_profile
        # remove this line
        # keep this line
    end

    def update
        # hehehehe
    end

    def get_booking_history
        booking_data = current_user.bookings
        return render json: {
            data: booking_data
        }
    end

    def get_detail_booking_history

    end
end
