require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should belong_to(:user) }

  it_behaves_like 'votable'
  it_behaves_like 'attachable'
  it_behaves_like 'commentable'

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(50) }
  it { should validate_length_of(:content).is_at_least(5).is_at_most(1000) }
end
