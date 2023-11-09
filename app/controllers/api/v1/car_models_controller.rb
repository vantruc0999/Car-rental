class Api::V1::CarModelsController < ApiController
    before_action :set_car_model, only: %i[show update destroy]
    skip_before_action :doorkeeper_authorize!, only: %i[index show]

    include ApiResponse

    def index
        render_success(CarModel.all, 'Car model loaded successfully', :created)
    end

    def show
        render_success(@car_model, "#{@car_model.name} loaded successfully", :created)
    end

    def create
        @carModel = CarModel.new(car_model_params)

        if @carModel.save
            render_success(@carModel, "#{@carModel.name} created successfully", :created)
        else
            render_error('Failed to create')
        end

    end

    def update
        if @carModel.update(car_model_params)
            render_success(@carModel, "#{@carModel.name} is updated successfully")
        else
            render_error('Failed to update')
        end
    end

    def destroy
        @car_model.destroy
        render_success(@car_model, "Car model deleted successfully")
    end

    private 

    def set_car_model
        @car_model = CarModel.find_by(id: params[:id])

        if !@car_model
            render_error("Car model not found")
        end
    end

    def car_model_params
        params.permit(:name, :description)
    end
end
