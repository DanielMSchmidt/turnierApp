set :output, "#{path}/log/cron.log"

every 1.week do
  runner "Club.mail_owner_unenrolled_tournaments"
end