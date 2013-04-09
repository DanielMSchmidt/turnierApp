TurnierList::Application.routes.draw do

  resources :progresses
  resources :couples

  get "/couple/levelup/:kind" => "couples#levelup", as: :couple_level_up

  match "/tournament/:id/enroll" => "tournaments#set_as_enrolled", as: :just_enrolled
  match "/user/:id/tournaments" => "tournaments#of_user", as: :user_tournaments
  match "/club/:club_id/transfer/:user_id" => "clubs#transfer_ownership", as: :transfer_ownership_to

  match "/membership/new/:user_id/:club_id" => "membership#create", as: :add_club
  match "/membership/verify/:user_id/:club_id" => "membership#verify", as: :verify_user
  match "/membership/delete/:user_id/:club_id" => "membership#destroy", as: :delete_club

  match "/impressum" => "home#impressum"


  resources :clubs
  resources :tournaments
  devise_for :users

  root :to => "home#index"
end
