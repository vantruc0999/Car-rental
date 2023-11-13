class Api::V1::CarsController < ApiController
    before_action :set_car, only: %i[show update destroy]
    skip_before_action :doorkeeper_authorize!, only: %i[index show]

    include ApiResponse
    include CarsConcern

    def index
        start_date = params['start_date']
        end_date = params['end_date']
        search_term = params['name']
        car_models = params['car_models']
        brands = params['brands']
        province = params['province']
        min_price = params['min_price']
        max_price = params['max_price']
        order = params[:order] || 'recommended'

        query = Car.where.not(
            id: Booking.where(booking_status: [11, 12, 20])
                      .where(
                        'booking_start <= ? AND booking_end >= ?',
                        end_date,
                        start_date
                      )
                      .pluck(:car_id)
        )   
        
        # if search_term
        #     query = query.joins(:brand, :car_model)
        #                .where('cars.name ILIKE ? OR brands.name ILIKE ? OR car_models.name ILIKE ?', "%#{search_term}%", "%#{search_term}%", "%#{search_term}%")
        # end

        return render json:{data: query}
    end 

    def show
        data = render_car_data(@car)
        render_success(data, 'Cars loaded successfully')
    end

    def recommend
        
    end

    def create
        @car = Car.new(car_params)
        if @car.save
            render_success(@car, "Car created successfully")
        else
            render_error(@car.errors)
        end
    end

    def update
        if @car.update(car_params)
            render_success(@car, "Car updated successfully")
        else
            render_error(@car.errors)
        end    
    end

    def destroy
        if @car.destroy
            render_success(@album, "car deleted successfully")
        else
            render_error(@car.errors)
        end
    end

    private 

    def set_car
        @car = Car.find_by(id: params[:id])

        if !@car
            render_error("Car not found")
        end
    end

    def car_params
        params.permit(:brand_id, :car_model_id, :name, :year, :color,
        :description, :address, :province, :seating_capacity, :fuel_type, :price_per_hour)
    end
end
