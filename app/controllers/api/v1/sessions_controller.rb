# -*- encoding : utf-8 -*-
module Api
  module V1
    class SessionsController < ActionController::Base
      def login
        head(403) and return unless check_params
        user = User.find_by_email(params[:email])

        if user && user.valid_password?(params[:password])
          render json: {token: user.authentication_token}
        else
          head(403)
        end
      end

      private
      def check_params
        params[:email].present? && params[:password].present?
      end
    end
  end
end