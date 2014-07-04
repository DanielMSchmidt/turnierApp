# -*- encoding : utf-8 -*-
module Api
  module V1
    class UsersController < Api::V1::ApiController
      def information
        render json: {test: true}, status: 200
      end
    end
  end
end