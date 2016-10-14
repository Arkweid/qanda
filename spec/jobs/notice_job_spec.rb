require 'rails_helper'

RSpec.describe NoticeJob, type: :job do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:subscription) { create(:subscription, question: question) }
  
  it 'Sends notification emails to subscribers ' do
    answer.question.subscriptions.each do |subscription|
      expect(NoticeMailer).to receive(:new_answer_added).with(subscription).and_call_original
    end
    NoticeJob.perform_now(answer)
  end
end
