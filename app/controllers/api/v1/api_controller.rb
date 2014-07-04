# -*- encoding : utf-8 -*-
module Api
  module V1
    class ApiController < ActionController::Base
      # This is our new function that comes before Devise's one
      before_filter :authenticate_user_from_token!

      private

      def authenticate_user_from_token!
        logger.debug "================================================================"
        logger.debug "Request: #{request.headers}"
        token = request.headers['HTTP_X_ACCESS_TOKEN']
        email = request.headers['HTTP_X_ACCESS_EMAIL']
        user = User.find_by_email(email) if email.present?

        logger.debug "Mail is #{email}"
        logger.debug "token is #{token}"
        logger.debug "User is #{user}"
        logger.debug "Secure compare result is #{Devise.secure_compare(user.authentication_token, token)}"
        # Notice how we use Devise.secure_compare to compare the token
        # in the database with the token given in the params, mitigating
        # timing attacks.
        if user && Devise.secure_compare(user.authentication_token, token)
          logger.debug "Logging in user. #{user}"
          sign_in user, store: false
        else
          head(403) and return
        end
      end
    end
  end
end