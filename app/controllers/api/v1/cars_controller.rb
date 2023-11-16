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
        provinces = params['provinces']
        min_price = params['min_price']
        max_price = params['max_price']
        order = params[:order] || 'recommended'
        rating = params[:rating]

        query = Car.where.not(
            id: Booking.where(booking_status: [11, 12, 20])
                      .where(
                        'booking_start <= ? AND booking_end >= ?',
                        end_date,
                        start_date
                      )
                      .pluck(:car_id)
        )   

        if order == 'recommended' || rating.present?
            query = query.left_outer_joins(:reviews)
                         .select('cars.*, AVG(reviews.rating) as average_rating')
                         .group('cars.id')
        end
        
        case order
        when 'price_asc'
          query = query.order('price_per_hour ASC')
        when 'price_desc'
          query = query.order('price_per_hour DESC')
        when 'recommended'
          query = query.order('average_rating DESC')
        end

        if rating.present?
            case rating.to_i
            when 1
              query = query.having('AVG(reviews.rating) < ?', 1)
            when 2
              query = query.having('AVG(reviews.rating) >= ? AND AVG(reviews.rating) < ?', 2, 3)
            when 3
              query = query.having('AVG(reviews.rating) >= ? AND AVG(reviews.rating) < ?', 3, 4)
            when 4
              query = query.having('AVG(reviews.rating) >= ? AND AVG(reviews.rating) < ?', 4, 5)
            when 5
              query = query.having('AVG(reviews.rating) = ?', 5)
            end
        end
        
        if search_term.present?
            query = query.joins(:brand, :car_model)
                         .where('cars.name LIKE ? OR brands.name LIKE ? OR car_models.name LIKE ?',
                                "%#{search_term}%", "%#{search_term}%", "%#{search_term}%")
        end
          
        brands = self::processAndFilter(brands)
        car_models = self::processAndFilter(car_models)
        provinces = self::processAndFilter(provinces)

        query = query.where(car_model_id: car_models) if car_models.present?
        query = query.where(brand_id: brands) if brands.present?
        query = query.where(province: provinces) if provinces.present?
    
        if min_price.present? && max_price.present?
            query = query.where('price_per_hour BETWEEN ? AND ?', min_price, max_price)
          elsif min_price.present?
            query = query.where('price_per_hour >= ?', min_price)
          elsif max_price.present?
            query = query.where('price_per_hour <= ?', max_price)
        end

        # data = CarSerializer.new(query).serializable_hash
        # return render_success(data, 'Car loaded successfully')

        render json: query.map { |car| CarSerializer.new(car).serializable_hash}
    end 

    def show
      HelloJob.perform_in(10.seconds, 'Hehehe', 'hahaha')
      render json: CarSerializer.new(@car, response_type: 'detail').serializable_hash
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

    def processAndFilter(input)
        return input.split(',').map(&:strip).reject(&:empty?)
    end

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
