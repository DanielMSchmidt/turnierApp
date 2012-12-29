require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  test "enrollCouples" do
    mail = NotificationMailer.enrollCouples
    assert_equal "Enrollcouples", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
