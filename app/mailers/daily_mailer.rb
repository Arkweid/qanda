class DailyMailer < ApplicationMailer
  class << self
    attr_accessor :questions
  end

  def digest(user)
    mail to: user.email, subject: 'Question digest'
  end
end
