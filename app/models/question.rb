class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  scope :from_yesterday, -> { where(created_at: 1.day.ago.all_day) }

  validates :user_id, :content, :title, presence: true

  validates :content, length: { in: 5..1000 }
  validates :title, length: { in: 5..50 }
end
