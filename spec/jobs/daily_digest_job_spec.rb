require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:mailer_double) { double(DailyMailer) }
  let!(:question){ create(:question, created_at: 1.day.ago) }

  it 'sends daily digest' do
    expect(DailyMailer).to receive(:digest).and_return(mailer_double)
    expect(mailer_double).to receive(:deliver_later)
    DailyDigestJob.perform_now
  end
end
