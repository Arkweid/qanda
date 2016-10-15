class DailyMailer < ApplicationMailer
  attr_accessor :questions

  def digest(user)
    mail to: user.email, subject: 'Question digest'
  end
end
