class NoticeMailer < ApplicationMailer
  def new_answer_added(subscription)
    @question = subscription.question

    mail to: subscription.user.email, subject: 'You recieve answer'
  end
end
