every :friday , at: '12pm' do
  rake "send_notifications"
  rake "sendUserNotification"
end
