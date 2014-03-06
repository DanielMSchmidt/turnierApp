# -*- encoding : utf-8 -*-
class CouplesController < ApplicationController

  # PUT /couples/1
  # PUT /couples/1.json
  def change
    if !params[:remove].nil?
      @couple = Couple.find(params[:id])
      @couple.destroy
      redirect_to root_path, notice: t('couple.destroy.success')
    else
      @couple = Couple.createFromParams(params, false)
      if @couple && @couple.consistsOfCurrentUser(current_user) && @couple.save
        @couple.activate
        # FIXME: Shouldn't be needed, investigate here!
        @couple.standard.start_class = @standard_class
        @couple.standard.save!
        @couple.latin.start_class = @latin_class
        @couple.latin.save!
        redirect_to root_path, notice: t('couple.update.success')
      else
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
end
