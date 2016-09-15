module AdditionalMethods
  extend ActiveSupport::Concern

  def blank_file(attributes)
    attributes['file'].blank?
  end

  def switch_best
    Answer.transaction do
      Answer.where(question_id: question.id).update_all(best: false) unless best
      toggle!(:best)
    end
  end
end
