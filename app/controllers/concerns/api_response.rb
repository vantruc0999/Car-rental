module ApiResponse
    extend ActiveSupport::Concern
  
    def render_success(data, message, status = 200)
      render json: {
        status: status,
        message: message,
        data: data
      }, status: status
    end
  
    def render_error(errors, status = 422)
      render json: {
        status: status,
        message: errors
      }, status: status
    end
end
  