module Api
    module V1
        module Users
            class AuthController < ApiController
                skip_before_action :doorkeeper_authorize!, only: %i[create confirm forgot reset]
            
                def create
                  user = User.new(email: user_params[:email], password: user_params[:password])
            
                  client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
            
                  return render(json: { error: 'Invalid client ID'}, status: 403) unless client_app
            
                  if user.save
                    # create access token for the user, so the user won't need to login again after registration
                    access_token = Doorkeeper::AccessToken.create(
                      resource_owner_id: user.id,
                      application_id: client_app.id,
                      refresh_token: generate_refresh_token,
                      expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
                      scopes: ''
                    )

                    url = 'http://127.0.0.1:3000/api/v1/users/confirm/' + user.confirmation_token
                    UserConfirmationMailer.with(user: user, url: url).confirm_email.deliver_later

                    # return json containing access token and refresh token
                    # so that user won't need to call login API right after registration
                    render(json: {
                      message: 'Success',
                      data: {
                        id: user.id,
                        email: user.email,
                        access_token: access_token.token,
                        token_type: 'bearer',
                        expires_in: access_token.expires_in,
                        refresh_token: access_token.refresh_token,
                        created_at: access_token.created_at.to_time.to_i
                      }
                    })
                  else
                    render(json: { error: user.errors.full_messages }, status: 422)
                  end
                end

                def confirm
                  token = params[:confirmation_token].to_s
                
                  user = User.find_by(confirmation_token: token)
                
                  if user.present? && user.confirmation_token_valid?
                    user.mark_as_confirmed!
                    render json: {status: 'User confirmed successfully'}, status: :ok
                  else
                    render json: {status: 'Invalid token'}, status: :not_found
                  end
                end

                def forgot
                  if params[:email].blank?
                    return render json: {error: 'Email not present'}
                  end
              
                  user = User.find_by(email: params[:email].downcase)
                  if user.present?
                    user.generate_password_token!
                    url = 'http://127.0.0.1:3000/api/v1/users/password/reset/' + user.reset_password_token
                    PasswordResetMailer.with(user: user, url: url).password_reset.deliver_later
                    render json: {status: 'ok'}, status: :ok
                  else
                    render json: {error: ['Email address not found. Please check and try again.']}, status: :not_found
                  end
                end
              
                def reset
                  token = params[:token].to_s

                  user = User.find_by(reset_password_token: token)
              
                  if user.present? && user.password_token_valid?
                    if user.reset_password!(params[:password])
                      render json: {status: 'ok'}, status: :ok
                    else
                      render json: {error: user.errors.full_messages}, status: :unprocessable_entity
                    end
                  else
                    render json: {error:  ['Link not valid or expired. Try generating a new link.']}, status: :not_found
                  end
                end
            
                private
            
                def user_params
                  params.permit(:email, :password)
                end
            
                def generate_refresh_token
                  loop do
                    # generate a random token string and return it, 
                    # unless there is already another token with the same string
                    token = SecureRandom.hex(32)
                    break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
                  end
                end 
            end
        end
    end
end