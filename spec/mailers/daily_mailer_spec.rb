require 'rails_helper'

RSpec.describe DailyMailer, type: :mailer do
  describe 'digest' do
    let(:questions) { create_list(:question, 2, created_at: 1.day.ago) }    
    let(:user) { create :user }
    let(:mail) { DailyMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Question digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@qanda.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Questions daily digest')
    end
  end
end

