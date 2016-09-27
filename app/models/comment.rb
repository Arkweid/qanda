class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :user_id, :content, presence: true
end