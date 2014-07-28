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
        tournament = current_user.tournaments.find{ |t| t.number == params[:number].to_i }
        head(:not_found) and return if tournament.nil?

        tournament.place        = params[:place].to_i
        tournament.participants = params[:participants].to_i

        if tournament.save
          head(:ok)
        else
          head(:not_acceptable)
        end
      end

      def destroy

      end
    end
  end
end