class MembershipController < ApplicationController
  def create
    puts Membership.create!(user_id: params[:user_id], club_id: params[:club_id])
    redirect_to edit_user_registration_path(current_user), notice: 'Club was successfully added.'
  end

  def destroy
    @membership = Membership.destroy_all(club_id: params[:club_id], user_id: params[:user_id])
    redirect_to edit_user_registration_path(current_user), notice: 'Club was successfully deleted.'
  end
end
