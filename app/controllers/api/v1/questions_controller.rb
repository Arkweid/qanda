class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with Question.find(params[:id])
  end

  def create
    respond_with(@question = Question.create(question_params))
  end
  
  private
  
  def question_params
    params.require(:question).permit(:title, :content).merge(user: current_resource_owner)
  end  
end