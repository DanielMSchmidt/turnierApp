# -*- encoding : utf-8 -*-
module Api
  module V1
    class UsersController < Api::V1::ApiController
      def information
        @user = current_user
        standard_obj = @user.activeCouple.standard
        latin_obj = @user.activeCouple.latin

        @startclass_goals = {
          latin: { points: latin_obj.maxPointsOfClass, placings: latin_obj.maxPlacingsOfClass },
          standard: { points: standard_obj.maxPointsOfClass, placings: standard_obj.maxPlacingsOfClass }
        }
      end

      def setPartner
        if params['man'].present?
          current_user.setPartner(params['man'], current_user.id)
        end

        if params['woman'].present?
          current_user.setPartner(current_user.id, params['woman'])
        end
      end
    end
  end
end