class MembershipController < ApplicationController
  def create
    Membership.create!(user_id: params[:user_id], club_id: params[:club_id], verified: false)
    redirect_to edit_user_registration_path(current_user), notice: 'Der Verein wurde erfolgreich zu deinen Vereinen hinzugefuegt. Sie muessen jetzt lediglich noch bestaetigt werden.'
  end

  def verify
    membership = Membership.where(user_id: params[:user_id], club_id: params[:club_id])
    if membership
      membership.verified = true
      membership.save!
      redirect_to  club_path(params[:club_id]), notice: 'Der Nuter wurde bestaetigt.'
    else
      redirect_to  club_path(params[:club_id]), notice: 'Der Nuter konnte nicht bestaetigt werden.'
    end
  end

  def destroy
    @membership = Membership.destroy_all(club_id: params[:club_id], user_id: params[:user_id])
    redirect_to edit_user_registration_path(current_user), notice: 'Der Verein wurde erfolgreich aus deinen Vereinen geloescht.'
  end

end
