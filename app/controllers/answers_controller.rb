class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: [:create]

  include Voted

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @question = @answer.question
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash[:success] = 'Your answer is successfully updated'
    else
      flash.now[:error] = 'You not owner of this answer'
    end
  end

  def destroy
    @question = @answer.question
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:success] = 'Your answer is successfully deleted.'
    else
      flash.now[:error] = 'You not owner of this answer'
    end
  end

  def best
    if current_user.author_of?(@answer.question)
      @answer.switch_best
    else
      flash[:error] = 'You not question owner'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:content, attachments_attributes: [:file])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
