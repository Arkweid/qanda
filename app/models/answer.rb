class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :question_id, :user_id, presence: true
  validates :content, presence: true, length: { in: 10..1000 }
end
