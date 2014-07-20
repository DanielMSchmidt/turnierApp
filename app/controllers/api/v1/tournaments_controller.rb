# -*- encoding : utf-8 -*-
module Api
  module V1
    class TournamentsController < Api::V1::ApiController
      respond_to :json

      def index
        @tournaments = current_user.tournaments
      end

      def create
        tournament = Tournament.newForUser({tournament: params.merge({user_id: current_user.id})})
        if tournament.valid?
          head(:created)
        else
          head(:not_acceptable)
        end

      end

      def update

      end

      def destroy

      end
    end
  end
end