class UserConfirmationMailer < ApplicationMailer
    def confirm_email
        @user = params[:user]
        @url = params[:url]
        @mail = @user.email
        @greeting = "Suppp"
        attachments['ong-putin-16797989949601625139011.jpg'] = File.read('app/assets/images/ong-putin-16797989949601625139011.jpg')
        mail(
          to: email_address_with_name(@mail, @mail),
          subject: "Confirm your password"
        ) 
    end
end
