class Api::V1::Users::UsersController < ApiController
    def get_user_profile
        
    end

    def update

    end

    def get_booking_history
        return render json: {
            data: current_user.bookings
        }
    end

    def get_detail_booking_history

    end
end
