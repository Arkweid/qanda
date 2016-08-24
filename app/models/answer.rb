class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :question_id, :content, :user_id, presence: true

  validates :content, length: { in: 10..1000 }
end
