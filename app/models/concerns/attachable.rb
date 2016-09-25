module Attachable
  extend ActiveSupport::Concern

  included do
    has_many :attachments, as: :attachable, dependent: :destroy

    accepts_nested_attributes_for :attachments, reject_if: :blank_file, allow_destroy: true
  end

  def blank_file(attributes)
    attributes['file'].blank?
  end
end
