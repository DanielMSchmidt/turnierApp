# -*- encoding : utf-8 -*-
class CouplesController < ApplicationController

  # POST /couples
  # POST /couples.json
  def create
    @couple = Couple.createFromParams(params, true)
    if @couple && @couple.consistsOfCurrentUser(current_user) && @couple.save
      @couple.activate
      redirect_to root_path, notice: t('couple.create.success')
    else
      redirect_to root_path, error: t('couple.create.fail')
    end
  end

  # PUT /couples/1
  # PUT /couples/1.json
  def update
    @couple = Couple.createFromParams(params, false)
    if @couple && @couple.consistsOfCurrentUser(current_user) && @couple.save
      @couple.activate
      # FIXME: Shouldn't be needed, investigate here!
      @couple.buildProgresses
      redirect_to root_path, notice: t('couple.update.success')
    else
      redirect_to root_path, error: t('couple.update.fail')
    end
  end

  # DELETE /couples/1
  # DELETE /couples/1.json
  def destroy
    @couple = Couple.find(params[:id])

    if @couple.belongsTo(current_user)
      @couple.deactivate # We don't destroy, we just deactivate
      Couple.createDummyCoupleFor(current_user)
      redirect_to root_path, notice: t('couple.destroy.success')
    else
      redirect_to root_path, notice: t('couple.destroy.fail')
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
