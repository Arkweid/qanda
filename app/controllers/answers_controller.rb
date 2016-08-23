class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    flash[:notice] = if @answer.save
                       'Your answer successfully saved'
                     else
                       'Answer not saved'
                     end
    redirect_to @question
  end

  def destroy
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer is successfully deleted.'
    end
    redirect_to @question
  end

  private

  def answer_params
    params.require(:answer).permit(:content)
  end
end
