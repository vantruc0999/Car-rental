class Api::V1::Users::UsersController < ApiController
    include ApiResponse

    def get_user_profile
        return render_success(current_user, 200)
    end

    def update
        # hahahaha
    end

    def get_booking_history
        booking_data = current_user.bookings
        return render json: {
            data: booking_data
        }
    end

    def get_detail_booking_history
        #kkkkk
        #heheheeh
    end
end
