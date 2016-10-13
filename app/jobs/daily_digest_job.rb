class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    #User.send_daily_digest
    User.ghost_method
  end
end
