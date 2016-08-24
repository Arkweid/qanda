class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    if @answer.save
      flash[:success] = 'Your answer successfully saved'
    else
      @question.answers.reload
      flash[:error] = 'Answer not saved'
    end
    redirect_to @question
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:success] = 'Your answer is successfully deleted.'
    else
      flash[:error] = 'You not owner of this answer'
    end
    redirect_to @question
  end

  private

  def answer_params
    params.require(:answer).permit(:content)
  end
end
