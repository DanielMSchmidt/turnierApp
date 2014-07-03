namespace :devise do
  desc "Sets an auth token for every user in the database (can savely be run multiple times"
  task :generateAuthtoken do
    User.all.each(&:ensure_authentication_token).each(&:save)
  end
end