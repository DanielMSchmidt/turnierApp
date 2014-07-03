# -*- encoding : utf-8 -*-
module Api
  module V1
    class SessionsController < ActionController::Base
      def login
        head(:ok)
      end

      def logout
        head(:ok)
      end
    end
  end
end