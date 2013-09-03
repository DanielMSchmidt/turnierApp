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

task :send_friday_notifications => :environment do
  puts "started send_friday_notifications"

  if Date.today.day == 4
    puts "Notification Task started"

    Club.all.each do |x|
      puts "Mailing to #{x.name} started"
      x.mailOwnerOfUnenrolledTournaments
      puts "Mailing to #{x.name} completed"
    end

    puts "Notification Task completed"
  else
    puts "task not sheduled because it isn't friday"
  end
end

task :sendUserNotification => :environment do
  User.sendUserNotification
end