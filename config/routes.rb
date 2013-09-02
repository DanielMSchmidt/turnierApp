# -*- encoding : utf-8 -*-
TurnierList::Application.routes.draw do

  resources :progresses, only: [:create, :update, :destroy]
  resources :couples, only: [:create, :update, :destroy]

  get "/couple/levelup/:kind" => "couples#levelup", as: :couple_level_up
  get "/couple/reset/:kind" => "couples#reset", as: :couple_reset
  match "/couple/change" => "couples#change", as: :change_active_couple

  match "/tournament/:id/enroll" => "tournaments#set_as_enrolled", as: :just_enrolled
  match "/user/:id/tournaments" => "tournaments#of_user", as: :user_tournaments

  post "/club/:club_id/print" => "clubs#printTournaments", as: :print_tournaments
  match "/club/:club_id/transfer/:user_id" => "clubs#transfer_ownership", as: :transfer_ownership_to

  match "/membership/new/:user_id/:club_id" => "membership#create", as: :add_club
  match "/membership/verify/:couple_id/:club_id" => "membership#verify", as: :verify_couple
  match "/membership/delete/:couple_id/:club_id" => "membership#destroy", as: :delete_couple

  match "/dashboard/(:club_id)" => "home#admin", as: :admin_dashboard

  match "/faq" => "home#faq"
  match "/impressum" => "home#impressum"


  resources :clubs, except: [:show, :index]
  resources :tournaments, except: [:show, :new, :index]
  devise_for :users

  root :to => "home#index"
end
