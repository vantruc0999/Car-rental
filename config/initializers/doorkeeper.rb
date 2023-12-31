# frozen_string_literal: true
require 'custom_token_error_response'
require 'custom_token_response'

Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (requires ORM extensions installed).
  # Check the list of supported ORMs here: https://github.com/doorkeeper-gem/doorkeeper#orms
  orm :active_record

  # This block will be called to check whether the resource owner is authenticated or not.
  # resource_owner_authenticator do
  #   raise "Please configure doorkeeper resource_owner_authenticator block located in #{__FILE__}"
  #   # Put your resource owner authentication logic here.
  #   # Example implementation:
  #   #   User.find_by(id: session[:user_id]) || redirect_to(new_user_session_url)
  # end

  resource_owner_from_credentials do |_routes|
    user = User.authenticate(params[:email], params[:password])
  
    if user && user.confirmed_at.present?
      user
    else
      nil
    end
  end

  access_token_expires_in 24.hours

  grant_flows %w[password]

  allow_blank_redirect_uri true

  skip_authorization do
    true
  end

  use_refresh_token

end

Doorkeeper::OAuth::ErrorResponse.send :prepend, CustomTokenErrorResponse
Doorkeeper::OAuth::TokenResponse.send :prepend, CustomTokenResponse