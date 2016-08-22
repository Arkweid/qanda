class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    if @answer.save
      flash[:notice] = 'Your answer successfully saved'
    else
      flash[:notice] = 'Answer not saved'
    end
    redirect_to @question
  end

  def destroy
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer is successfully deleted.'
      redirect_to @question
    end
  end  

  private

  def answer_params
    params.require(:answer).permit(:content)
  end
end