class AnswersController < ApplicationController
  byebug
  def create
    @question = Question.find(params[:question_id])
    @question.answers.create(answer_params)
    redirect_to @question
  end
  
  def update
  end
  
  def destroy
  end
  
  private
  
  def answer_params
    params.require(:answer).permit(:content)
  end  
end