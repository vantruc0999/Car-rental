class Api::V1::CarsController < ApiController
    before_action :set_car, only: %i[show update destroy]
    skip_before_action :doorkeeper_authorize!, only: %i[index show]

    include ApiResponse
    include CarsConcern

    def index
        @cars = Car.all
        data = render_car_data(@cars)
        render_success(data, 'Cars loaded successfully')
    end 

    def show
        data = render_car_data(@car)
        render_success(data, 'Cars loaded successfully')
    end

    def search_car
        
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

    end

    def destroy

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
