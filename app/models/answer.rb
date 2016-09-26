class Answer < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  validates :question_id, :content, :user_id, presence: true

  validates :content, length: { in: 10..1000 }

  def switch_best
    Answer.transaction do
      Answer.where(question_id: question.id).update_all(best: false) unless best
      toggle!(:best)
    end
  end
end
