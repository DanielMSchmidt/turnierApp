# -*- encoding : utf-8 -*-
class MembershipController < ApplicationController
  def create
    Membership.create!(couple_id: params[:couple_id], club_id: params[:club_id], verified: false)
    redirect_to clubs_path, notice: t('membership create')
  end

  def verify
    membership = Membership.where(couple_id: params[:couple_id], club_id: params[:club_id]).first
    if membership
      membership.verified = true
      membership.save!
      redirect_to  club_path(params[:club_id]), notice: t('membership verfify success')
    else
      redirect_to  club_path(params[:club_id]), notice: t('membership verfify fail')
    end
  end

  def destroy
    @membership = Membership.destroy_all(club_id: params[:club_id], couple_id: params[:couple_id])
    redirect_to edit_user_registration_path(current_user), notice: t('membership destroy')
  end
end
