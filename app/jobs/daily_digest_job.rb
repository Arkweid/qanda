class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    DailyMailer.questions = Question.from_yesterday

    User.find_each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end
end
