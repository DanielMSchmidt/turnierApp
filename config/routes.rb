# -*- encoding : utf-8 -*-
TurnierList::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :progresses, only: [:create, :update, :destroy]
  resources :couples, only: [:create, :update, :destroy]

  get "/couple/levelup/:kind" => "couples#levelup", as: :couple_level_up
  get "/couple/reset/:kind" => "couples#reset", as: :couple_reset
  match "/couple/change" => "couples#change", as: :change_active_couple

  match "/tournament/:id/enroll" => "tournaments#setAsEnrolled", as: :just_enrolled
  match "/user/:id/tournaments" => "tournaments#ofUser", as: :user_tournaments
  post "/club/:club_id/cancel/tournament/" => "clubs#cancel", as: :tournament_cancel

  post "/club/:club_id/print" => "clubs#printTournaments", as: :print_tournaments
  match "/club/:club_id/transfer/:user_id" => "clubs#transferOwnership", as: :transferOwnership_to

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
