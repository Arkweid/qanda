class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    question_list = Question.from_yesterday

    User.find_each do |user|
      DailyMailer.digest(user, question_list).deliver_later
    end
  end
end
