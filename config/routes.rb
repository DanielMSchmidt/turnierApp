# -*- encoding : utf-8 -*-
TurnierList::Application.routes.draw do
  require 'sidekiq/web'
  require 'sidetiq/web'

  # Todo: Solve nicer
  authenticate :user, lambda { |u| u.email == 'daniel.maximilian@gmx.net' } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :progresses, only: [:create, :update, :destroy]
  resources :couples, only: [:create, :update, :destroy]

  get "/couple/levelup/:kind" => "couples#levelup", as: :couple_level_up
  get "/couple/reset/:kind" => "couples#reset", as: :couple_reset
  match "/couple/change" => "couples#change", as: :change_active_couple
  get "/couple/remove/:id" => "couples#destroy", as: :remove_active_couple
  post "/couple/:couple_id/print/planning" => "couples#printPlanning", as: :print_planning

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

  namespace :api do
    namespace :v1 do
      post '/login' => "sessions#login"

      get '/user' => "users#information"
    end
  end


  resources :clubs, except: [:show, :index]
  resources :tournaments, except: [:show, :new, :index]
  devise_for :users

  root :to => "home#index"
end
