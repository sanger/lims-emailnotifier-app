require 'net/smtp'

message = <<MESSAGE_END
From: <s2-emailnotifier-noreply@sanger.ac.uk>
To: Me <ke4@sanger.ac.uk>
Subject: SMTP e-mail test

This is a test e-mail message.
MESSAGE_END

Net::SMTP.start('mail.sanger.ac.uk') do |smtp|
  smtp.send_message message, 's2-noreply@sanger.ac.uk', 
                             'ke4@sanger.ac.uk'
end
