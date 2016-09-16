module AdditionalMethods
  extend ActiveSupport::Concern

  def blank_file(attributes)
    attributes['file'].blank?
  end
end
