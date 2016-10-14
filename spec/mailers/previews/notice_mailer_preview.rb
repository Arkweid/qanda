# Preview all emails at http://localhost:3000/rails/mailers/notice_mailer
class NoticeMailerPreview < ActionMailer::Preview
  def new_answer_added
    NoticeMailer.new_answer_added(Answer.first)
  end
end
