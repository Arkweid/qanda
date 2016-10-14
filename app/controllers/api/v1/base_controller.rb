class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  # CanCan use current_user for instance Ability class,
  # but for API tests its not available.
  # We must redefine this method directly, or @ability will be nil
  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end
