# frozen_string_literal: true

class ApiController < ApplicationController
    # equivalent of authenticate_user! on devise, but this one will check the oauth token
    # before_action :authenticate_user!
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    
    before_action :doorkeeper_authorize!
  
    # Skip checking CSRF token authenticity for API requests.
    skip_before_action :verify_authenticity_token
  
    # Set response type
    respond_to :json
  
    def doorkeeper_unauthorized_render_options error
      {
        json: {
          status: 401,
          errors: I18n.t("doorkeeper.errors.messages.unauthorized_client", uid: current_user&.id)
        }
      }
    end
    
    # helper method to access the current user from the token
    def current_user
      return unless doorkeeper_token
  
      @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id])
    end

    private

    def user_not_authorized
      return render json: {status: 401, message: 'You do not have permission to access this page'}
    end
end