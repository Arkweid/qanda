require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(50) }
  it { should validate_length_of(:content).is_at_least(5).is_at_most(1000) }

  it { should accept_nested_attributes_for :attachments}
end
