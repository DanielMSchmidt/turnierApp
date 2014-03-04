# -*- encoding : utf-8 -*-
class CouplesController < ApplicationController

  # POST /couples
  # POST /couples.json
  def create
    @couple = Couple.createFromParams(params ,true)
    if @couple.consistsOfCurrentUser(current_user)
      if @couple.save
        @couple.activate
        redirect_to root_path, notice: t('couple.create.success')
      end
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
      @couple.standard.start_class = @standard_class
      @couple.standard.save!
      @couple.latin.start_class = @latin_class
      @couple.latin.save!
      redirect_to root_path, notice: t('couple.update.success')
    else
      redirect_to root_path, error: t('couple.create.fail')
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
end
