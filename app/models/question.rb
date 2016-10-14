class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  scope :from_yesterday, -> { where(created_at: (Time.now - 1.day).beginning_of_day.utc..(Time.now - 1.day).end_of_day.utc) }

  validates :user_id, :content, :title, presence: true

  validates :content, length: { in: 5..1000 }
  validates :title, length: { in: 5..50 }
end
