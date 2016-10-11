class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: [:create]
  before_action :load_question, only: [:create]
  after_action :publish_answer, only: [:create]

  authorize_resource

  include Voted

  respond_to :js, only: [:create, :update, :destroy, :best]

  def create
    @answer = @question.answers.create(answer_params)
    respond_with @answer
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def best
    respond_with(@answer.switch_best)
  end

  private

  def answer_params
    params.require(:answer).permit(:content, attachments_attributes: [:file]).merge(user: current_user)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def publish_answer
    PrivatePub.publish_to("/questions/#{ @answer.question_id }/answers", answer: @answer.to_json) if @answer.valid?
  end
end
