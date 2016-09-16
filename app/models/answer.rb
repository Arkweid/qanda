class Answer < ActiveRecord::Base
  include AdditionalMethods

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :question_id, :content, :user_id, presence: true

  validates :content, length: { in: 10..1000 }

  accepts_nested_attributes_for :attachments, reject_if: :blank_file, allow_destroy: true

  def switch_best
    Answer.transaction do
      Answer.where(question_id: question.id).update_all(best: false) unless best
      toggle!(:best)
    end
  end
end
