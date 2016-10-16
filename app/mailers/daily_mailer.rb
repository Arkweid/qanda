class DailyMailer < ApplicationMailer
  def digest(user, question_list)
    @questions = question_list

    mail to: user.email, subject: 'Question digest'
  end
end
