class Api::V1::BrandsController < ApiController
    before_action :set_brand, only: %i[show update destroy]
    before_action :authorize_user, except: %i[index show]
    skip_before_action :doorkeeper_authorize!, only: %i[index show]

    include ApiResponse

    def index
        render_success(Brand.all, 'Brand loaded successfully', :created)
    end

    def show
        render_success(@brand, "#{@brand.name} loaded successfully", :created)
    end

    def create
        @brand = Brand.new(brand_params)

        if @brand.save
            render_success(@brand, "#{@brand.name} created successfully", :created)
        else
            render_error('Failed to create brand')
        end

    end

    def update
        if @brand.update(brand_params)
            render_success(@brand, "#{@brand.name} is updated successfully")
        else
            render_error('Failed to update brand')
        end
    end

    def destroy
        @brand.destroy
        render_success(@brand, "brand deleted successfully")
    end

    private

    def set_brand
        @brand = Brand.find_by(id: params[:id])

        if !@brand
            render_error("Brand not found")
        end
    end

    def authorize_user
        brand = @brand || Brand
        authorize brand
    end

    def brand_params
        params.permit(:name, :description)
    end
end
