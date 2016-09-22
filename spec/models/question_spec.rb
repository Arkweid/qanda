require 'rails_helper'
require Rails.root.join('spec/models/concerns/votable_spec')
require Rails.root.join('spec/models/concerns/attachable_spec')

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }

  it_behaves_like 'votable'
  it_behaves_like 'attachable'

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(50) }
  it { should validate_length_of(:content).is_at_least(5).is_at_most(1000) }
end
