class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    if @answer.save
      redirect_to @question
    else
      @answers = @question.answers.reload
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:content)
  end
end