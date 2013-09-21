desc "This task is called by the Heroku scheduler add-on"
task :test_sheduler => :environment do
  puts "sheduler task works fine"
end

task :send_notifications => :environment do
  puts "Notification Task started"

  Club.all.each do |x|
    puts "Mailing to #{x.name} started"
    x.mailOwnerOfUnenrolledTournaments
    puts "Mailing to #{x.name} completed"
  end

  puts "Notification Task completed"
end

task :sendUserNotification => :environment do
  User.sendUserNotification
end