require 'rails_helper'

RSpec.describe NoticeMailer, type: :mailer do
  describe 'digest' do
    let(:question) { create :question }
    let(:answer) { create :answer, question: question }
    let(:mail) { NoticeMailer.new_answer_added(answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('You recieve answer')
      expect(mail.to).to eq([answer.user.email])
      expect(mail.from).to eq(['noreply@qanda.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('You recieve answer for you question')
    end
  end
end
