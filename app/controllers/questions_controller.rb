class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: [:show]
  # after_action :publish_question, only: [:create]

  include Voted

  respond_to :json

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@answers = @question.answers)
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    @question = Question.create(question_params)
    respond_with @question
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    if current_user.author_of?(@question)
      respond_with(@question.destroy)
    else
      render 'questions/show'
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def question_params
    params.require(:question).permit(:title, :content, attachments_attributes: [:file, :id, :_destroy]).merge(user: current_user)
  end

  def publish_question
    PrivatePub.publish_to('/questions', question: @question.to_json) if @question.valid?
  end
end
