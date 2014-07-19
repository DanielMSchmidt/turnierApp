# -*- encoding : utf-8 -*-
module Api
  module V1
    class TournamentsController < Api::V1::ApiController
      respond_to :json

      def index
        @tournaments = current_user.tournaments
      end

      def create

      end

      def update

      end

      def destroy

      end
    end
  end
end