# -*- encoding : utf-8 -*-
class CouplesController < ApplicationController

  # PUT /couples/1
  # PUT /couples/1.json
  def change
    if !params[:remove].nil?
      @couple = Couple.find(params[:id])
      @couple.destroy if @couple.consistsOfCurrentUser(current_user)
      redirect_to root_path, notice: t('couple.destroy.success')
    else
      begin
        @couple = Couple.createFromParams(params, current_user, false)
        @couple.activate
        redirect_to root_path, notice: t('couple.update.success')
      rescue PartnersNotSet, DoesntConsistOfUser, InvalidCouple => e
        logger.error "Couldn't change the couple #{e.message}"
        redirect_to root_path, error: t('couple.update.fail')
      end
    end
  end

  # TODO: Dry up
  def levelup
    couple = current_user.activeCouple
    if params[:kind] == 'latin'
      couple.latin.levelUp
    else
      couple.standard.levelUp
    end
    respond_to :js
  end

  def reset
    couple = current_user.activeCouple
    if params[:kind] == 'latin'
      couple.latin.reset
    else
      couple.standard.reset
    end
    respond_to :js
  end

  def printPlanning
    type = (params[:tournament_type] == 'standard') ? ->(x){ x.standard? } : ->(x){ x.latin? }
    @year = params[:date][:year]
    @aims = params[:aims]
    @progression = params[:progression]
    @training = params[:training]
    @period = params[:period]
    couple = Couple.find(params[:couple_id])

    @plannedTournaments = couple.tournamentsForYear(@year).select(&type).select{|x| x.upcoming? }

    render :pdf => "planung",
           :show_as_html => false
  end
end
