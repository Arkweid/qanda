module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:like, :dislike, :change_vote, :cancel_vote]

    respond_to :json, only: [:like, :dislike, :change_vote, :cancel_vote]
  end

  def like
    respond_with(@votable.set_evaluate(current_user, 1), template: 'votes/vote.json.jbuilder')
  end

  def dislike
    respond_with(@votable.set_evaluate(current_user, -1), template: 'votes/vote.json.jbuilder')
  end

  def change_vote
    respond_with(@votable.change_evaluate(current_user), template: 'votes/vote.json.jbuilder')
  end

  def cancel_vote
    respond_with(@votable.cancel_evaluate(current_user), template: 'votes/vote.json.jbuilder')
  end

  private

  def load_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
end
